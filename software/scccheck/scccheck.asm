; ------------------------------------------------------------------------------------------------
; SCC�ɑ΂��ăA�N�Z�X���邽�߂̍ŏ����̃v���O����
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
			; �X���b�g�̊g���󋵂𒲂ׂ�
			ld		hl, exptbl
			xor		a, a				; SLOT#0 ����J�n
base_slot_loop:
			ld		b, a
			ld		a, [hl]
			and		a, 0x80				; A = 00h: �g���X���b�g����, 80h: �g���X���b�g����
			or		a, b
			ld		[current_slot], a
			push	hl
check_slot:
			; page2 (8000h-BFFFh) �� ���ڃX���b�g�ɐ؂�ւ���
			ld		h, 0x80
			call	enaslt
			; scc_reg_b (�̉\���̂���A�h���X) �̓��e��ۑ����Ă���
			; �݊����[�h�ɐݒ肷��l����������
			ld		a, [scc_reg_b]
			ld		[backup_scc_reg_b], a
			xor		a, a
			ld		[scc_reg_b], a
			; scc_bank2 (�̉\���̂���A�h���X) �̓��e��ۑ����Ă���
			; ���W�X�^�o���o���N�ɐݒ肷��l����������
			ld		a, [scc_bank2]
			ld		[backup_scc_bank2], a
			ld		a, scc_bank2_wave_bank
			ld		[scc_bank2], a
			; 98A0h �� SCC+ �Ȃ� Ch.E �̔g�`(ReadOnly), SCC �Ȃ疳���B�����������Ȃ����Ƃ��m�F����
			ld		hl, 0x98A0
			call	check_access
			jp		z, is_not_scc		; RAM �������� is_not_scc ��
			; 9800h �� SCC/SCC+ �Ȃ� Ch.A �̔g�`(Read/Write)�B�����������邱�Ƃ��m�F����
			ld		hl, 0x9800
			call	check_access
			jp		nz, is_not_scc		; ROM �������� is_not_scc ��
			; ���̎��_�� SCC/SCC-I �̂ǂ��炩�ł��邱�Ƃ͊m��
			; �ŗL���[�h�ɐݒ肷��l����������
			ld		a, scc_reg_b_new_mode
			ld		[scc_reg_b], a
			ld		a, 0x80
			ld		[scc_bank3], a
			ret

check_next_slot:
			ld		a, [current_slot]
			or		a, a
			jp		p, slot_is_not_expanded

			add		a, 0x04		; ���̊g���X���b�g�ԍ��ɃC���N�������g����
			bit		4, a		; SLOT#X-4 �ɂȂ��Ă��܂�����A��{�X���b�g�̃C���N�������g�ցB
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

			; EXPTBL �̃A�h���X�̒l�� SLOT#X �� X �ɕϊ�����
			inc		hl
			and		a, 0x03
			jp		base_slot_loop

is_not_scc:
			; ���W�X�^�̂���ŏ����ւ������e�������߂�
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
;	data �� 1byte�B�������ׂ�ƃA�h���X�I�[�g�C���N�������g�ŏ������܂��B
;	data �͍ő�32�܂ŕ��ׂ���B
;	�Ώۂ� page2 �̂݁Baddress �� MSB2bit �́A������ 10 �ɒu����������B
;------------------------------------------------------------------------------
			scope	scc_poke
scc_poke::
			pop		hl

			ret
			endscope

;------------------------------------------------------------------------------
;	_SCCPEEK( address, variable )
;
;	variable �� INT�^�ϐ����Baddress ��ǂݏo���Ċi�[����B
;	�Ώۂ� page2 �̂݁Baddress �� MSB2bit �́A������ 10 �ɒu����������B
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
