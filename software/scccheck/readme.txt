SCC-CHECK
-------------------------------------------------------------------------------

1. �C���X�g�[�����@
	BLOAD "SCCCHECK.BIN",R

2. �ǉ�����
	_SCCPOKE( address, data0 [, data1 [, data2 [, data3 [...[, data31]...]]]] )
		address �� data0, address+1 �� data1 ... ���������ށB
		1byte ����A�ő� 32byte �܂ŏ������߂�d�l�B

	_SCCPEEK( address, int_variable )
		��2�����ɂ͐����^�ϐ������L�����邱�ƁB
		address �̒l�� int_variable �Ɋi�[�����B

-------------------------------------------------------------------------------
2021/Oct/6th	HRA! (t.hara)
