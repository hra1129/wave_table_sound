SCC-CHECK
-------------------------------------------------------------------------------

1. インストール方法
	BLOAD "SCCCHECK.BIN",R

2. 追加命令
	_SCCPOKE( address, data0 [, data1 [, data2 [, data3 [...[, data31]...]]]] )
		address に data0, address+1 に data1 ... を書き込む。
		1byte から、最大 32byte まで書き込める仕様。

	_SCCPEEK( address, int_variable )
		第2引数には整数型変数名を記入すること。
		address の値が int_variable に格納される。

-------------------------------------------------------------------------------
2021/Oct/6th	HRA! (t.hara)
