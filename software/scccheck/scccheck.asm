; ------------------------------------------------------------------------------------------------
; SCCに対してアクセスするための最小限のプログラム
; Copyright 2021 t.hara
; 
;  Permission is hereby granted, free of charge, to any person obtaining a copy 
; of this software and associated documentation files (the "Software"), to deal 
; in the Software without restriction, including without limitation the rights 
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
; of the Software, and to permit persons to whom the Software is furnished to do
; so, subject to the following conditions:
; 
; The above copyright notice and this permission notice shall be included in all 
; copies or substantial portions of the Software.
; 
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
; INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
; PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
; HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
; OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH 
; THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
; ------------------------------------------------------------------------------------------------; -----------------------------------------------------------------------------

			include		"../zma/MSXBIOS.ASM"

scc_bank2					:= 0x9000
scc_bank3					:= 0xB000
scc_reg_a					:= 0x7FFE
scc_reg_b					:= 0xBFFE

scc_reg_b_ram_write_en		:= 0b0001_0000
scc_reg_b_new_mode			:= 0b0010_0000
scc_bank2_wave_bank			:= 0x3F

			org		0
			db		0xFE
			dw		start_address
			dw		end_address + (end_address_on_page1 - start_address_on_page1)
			dw		start_address

			org		0xC000
start_address::
			ld		a, [ramad1]
			ld		h, 0x40
			call	enaslt

			ld		hl, end_address
			ld		de, start_address_on_page1
			ld		bc, end_address_on_page1 - start_address_on_page1
			ldir

			call	init

			ld		a, [exptbl]
			ld		h, 0x40
			call	enaslt
			ei
			ret

end_address::
			org		0x4000
start_address_on_page1:
rom_header::
			ds		"AB"					; ID
			dw		init					; INIT
			dw		call_interpreter		; STATEMENT
			dw		0x0000					; DEVICE
			dw		0x0000					; TEXT
			dw		0x0000					; RESERVE
			dw		0x0000					; RESERVE
			dw		0x0000					; RESERVE

call_interpreter::

			scope	command_search
command_search::
			push	hl
			ld		hl, command_table
search_loop:
			ld		bc, procnm
			; get address
			ld		e, [hl]
			inc		hl
			ld		d, [hl]
			inc		hl
			ld		a, e
			or		a, d
			jr		nz, strcmp_loop
			pop		hl
			ret								; not found
strcmp_loop:
			ld		a, [bc]
			cp		a, [hl]
			jr		nz, skip_remain_char
			or		a, a
			jr		z, exit_strcmp_loop
			inc		bc
			inc		hl
			jr		strcmp_loop
skip_remain_char:
			ld		a, [hl]
			or		a, a
			inc		hl
			jr		nz, skip_remain_char
			jr		search_loop
exit_strcmp_loop:
			ex		de, hl
			jp		hl
			endscope

;------------------------------------------------------------------------------
;	Initialize this program
;------------------------------------------------------------------------------
			scope	init
init::
			; スロットの拡張状況を調べる
			ld		hl, exptbl
			xor		a, a				; SLOT#0 から開始
base_slot_loop:
			ld		b, a
			ld		a, [hl]
			and		a, 0x80				; A = 00h: 拡張スロット無し, 80h: 拡張スロットあり
			or		a, b
			ld		[current_slot], a
			push	hl
check_slot:
			; page2 (8000h-BFFFh) を 着目スロットに切り替える
			ld		h, 0x80
			call	enaslt
			; scc_reg_b (の可能性のあるアドレス) の内容を保存してから
			; 互換モードに設定する値を書き込む
			ld		a, [scc_reg_b]
			ld		[backup_scc_reg_b], a
			xor		a, a
			ld		[scc_reg_b], a
			; scc_bank2 (の可能性のあるアドレス) の内容を保存してから
			; レジスタ出現バンクに設定する値を書き込む
			ld		a, [scc_bank2]
			ld		[backup_scc_bank2], a
			ld		a, scc_bank2_wave_bank
			ld		[scc_bank2], a
			; 98A0h は SCC+ なら Ch.E の波形(ReadOnly), SCC なら無効。ここが書けないことを確認する
			ld		hl, 0x98A0
			call	check_access
			jp		z, is_not_scc		; RAM だったら is_not_scc へ
			; 9800h は SCC/SCC+ なら Ch.A の波形(Read/Write)。ここが書けることを確認する
			ld		hl, 0x9800
			call	check_access
			jp		nz, is_not_scc		; ROM だったら is_not_scc へ
			; この時点で SCC/SCC-I のどちらかであることは確定
			; 固有モードに設定する値を書き込む
			ld		a, scc_reg_b_new_mode
			ld		[scc_reg_b], a
			ld		a, 0x80
			ld		[scc_bank3], a
			ret

check_next_slot:
			ld		a, [current_slot]
			or		a, a
			jp		p, slot_is_not_expanded

			add		a, 0x04		; 次の拡張スロット番号にインクリメントする
			bit		4, a		; SLOT#X-4 になってしまったら、基本スロットのインクリメントへ。
			jp		nz, next_basic_slot
			ld		[current_slot], a
			jp		check_slot

slot_is_not_expanded:
next_basic_slot:
			pop		hl
			ld		a, 0xFF
			ld		[current_slot], a
			ld		a, l
			cp		a, 0xC4
			ret		z

			; EXPTBL のアドレスの値を SLOT#X の X に変換する
			inc		hl
			and		a, 0x03
			jp		base_slot_loop

is_not_scc:
			; レジスタのつもりで書き替えた内容を書き戻す
			ld		a, [backup_scc_bank2]
			ld		[scc_bank2], a
			ld		a, [backup_scc_reg_b]
			ld		[scc_reg_b], a

check_access:
			ld		a, [hl]
			cpl
			ld		[hl], a
			cp		a, [hl]
			cpl
			ld		[hl], a
			ret
			endscope

;------------------------------------------------------------------------------
;	_SCCPOKE( address, data [, data [, data ...]] )
;
;	data は 1byte。複数並べるとアドレスオートインクリメントで書き込まれる。
;	data は最大32個まで並べられる。
;	対象は page2 のみ。address の MSB2bit は、内部で 10 に置き換えられる。
;------------------------------------------------------------------------------
			scope	scc_poke
scc_poke::
			pop		hl

			ret
			endscope

;------------------------------------------------------------------------------
;	_SCCPEEK( address, variable )
;
;	variable は INT型変数名。address を読み出して格納する。
;	対象は page2 のみ。address の MSB2bit は、内部で 10 に置き換えられる。
;------------------------------------------------------------------------------
			scope	scc_peek
scc_peek::
			pop		hl

			ret
			endscope

;------------------------------------------------------------------------------
decect_scc_slot::
current_slot::
			db		0
backup_scc_reg_b::
			db		0
backup_scc_bank2:
			db		0

;------------------------------------------------------------------------------
command_item		macro	address, name
			dw		address
			ds		name
			db		0
					endm

command_table::
			command_item	scc_poke, "SCCPOKE"
			command_item	scc_peek, "SCCPEEK"
			dw		0
end_address_on_page1:
