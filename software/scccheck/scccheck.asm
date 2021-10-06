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
scc_bank3_scci_bank			:= 0x80

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

			; get current slot#
			di
			in		a, [0xA8]			; primary slot
			and		a, 0x0C				; 0000PP00
			rlca
			rlca
			ld		e, a				; 00PP0000

			ld		hl, 0xFCC5
			rrca
			rrca
			rrca
			rrca
			add		a, l				; 000000PP + 0xC5
			ld		l, a
			ld		a, [hl]				; extended slot
			and		a, 0x0C				; 0000EE00
			or		a, e
			ld		e, a
			ld		d, 0

			ld		hl, 0xFCC9 + 1
			add		hl, de
			ld		a, 1 << 5			; statement extension flag
			ld		[hl], a

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
			call	enaslt				; DI
			; 書き替える領域をバックアップ (無関係なRAMだった場合に戻せるようにする)
			ld		a, [scc_reg_a]
			ld		[backup_scc_reg_a], a
			ld		a, [scc_reg_b]
			ld		[backup_scc_reg_b], a
			ld		a, [scc_bank2]
			ld		[backup_scc_bank2], a
			ld		a, [scc_bank3]
			ld		[backup_scc_bank3], a
			; scc_bank2 (の可能性のあるアドレス) の内容を保存してから
			; レジスタ出現バンクに設定する値を書き込む
			ld		a, scc_bank2_wave_bank
			ld		[scc_bank2], a
			; scc_bank3 (の可能性のあるアドレス) の内容を保存してから
			; レジスタ出現バンクに設定する値を書き込む
			ld		a, scc_bank3_scci_bank
			ld		[scc_bank3], a
			; scc_reg_a (の可能性のあるアドレス) の内容を保存してから
			; 互換モードに設定する値を書き込む
			xor		a, a
			ld		[scc_reg_a], a
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
			; スロットを元に戻す
			ld		a, [ramad2]
			ld		h, 0x80
			call	enaslt				; DI
			pop		hl
			ret

is_not_scc:
			; レジスタのつもりで書き替えた内容を書き戻す
			ld		a, [backup_scc_bank2]
			ld		[scc_bank2], a
			ld		a, [backup_scc_reg_b]
			ld		[scc_reg_b], a
			ld		a, [backup_scc_reg_a]
			ld		[scc_reg_a], a

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

			; check '('
			dec			hl
			ld			ix, calbas_chrgtr
			call		calbas
			cp			a, '('
			jp			nz, syntax_error
			inc			hl

			; address
			ld			ix, calbas_frmqnt
			call		calbas
			ld			[data_address], de

			; check ','
			dec			hl
			ld			ix, calbas_chrgtr
			call		calbas
			cp			a, ','
			jp			nz, syntax_error
			inc			hl

			ld			b, 32
			ld			de, data_work
loop:
			push		bc
			push		de
			ld			ix, calbas_getbyt
			call		calbas
			pop			de
			ld			[de], a
			inc			de

			; check ')' or ','
			dec			hl
			push		de
			ld			ix, calbas_chrgtr
			call		calbas
			pop			de
			pop			bc
			inc			hl
			cp			a, ')'
			jp			z, exit_loop
			cp			a, ','
			jp			nz, syntax_error
			djnz		loop
			jp			syntax_error

exit_loop:
			push		hl
			ld			a, b
			dec			a
			xor			a, 31
			inc			a
			ld			c, a
			ld			b, 0
			push		bc

			ld			a, [detect_scc_slot]
			ld			h, 0x80
			call		enaslt

			ld			de, [data_address]
			ld			a, d
			or			a, 0x80
			ld			d, a
			ld			hl, data_work
			pop			bc
			ldir

			ld			a, [ramad2]
			ld			h, 0x80
			call		enaslt
			pop			hl
			ei
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

			; check '('
			dec			hl
			ld			ix, calbas_chrgtr
			call		calbas
			cp			a, '('
			jp			nz, syntax_error
			inc			hl

			; address
			ld			ix, calbas_frmqnt
			call		calbas
			ld			[data_address], de

			; データを読む
			push		hl
			ld			a, [detect_scc_slot]
			ld			h, 0x80
			call		enaslt

			ld			hl, [data_address]
			ld			a, [hl]
			ld			[data_work], a

			ld			a, [ramad2]
			ld			h, 0x80
			call		enaslt
			ei
			pop			hl

			; check ','
			dec			hl
			ld			ix, calbas_chrgtr
			call		calbas
			cp			a, ','
			jp			nz, syntax_error
			inc			hl

			xor			a, a
			ld			[subflg], a
			ld			ix, calbas_ptrget
			call		calbas
			dec			de
			dec			de
			dec			de
			ld			a, [de]
			cp			a, 2
			jp			nz, type_mismatch_error
			inc			de
			inc			de
			inc			de

			ld			a, [data_work]
			ld			[de], a
			inc			de
			xor			a, a
			ld			[de], a

			; check ')'
			dec			hl
			ld			ix, calbas_chrgtr
			call		calbas
			cp			a, ')'
			jp			nz, syntax_error
			inc			hl

			ret
			endscope

; ==============================================================================
;	Syntax error
; ==============================================================================
			scope		syntax_error
syntax_error::
			ld			e, 2
			ld			ix, calbas_errhand
			jp			calbas
			endscope

; ==============================================================================
;	type mismatch
; ==============================================================================
			scope		type_mismatch_error
type_mismatch_error::
			ld			e, 13
			ld			ix, calbas_errhand
			jp			calbas
			endscope

;------------------------------------------------------------------------------
data_address::
			dw			0
data_work::
			space		32

;------------------------------------------------------------------------------
detect_scc_slot::
current_slot::
			db		0
backup_scc_reg_a::
			db		0
backup_scc_reg_b::
			db		0
backup_scc_bank2:
			db		0
backup_scc_bank3:
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
