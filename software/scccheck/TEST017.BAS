100 DEFINTA-Z
110 SCREEN1:COLOR15,4,7:PRINT"Nokogiri wave test"
120 _SCCPOKE(&H9000,63)
130 _SCCPOKE(&H9800,62,60,58,56,54,52,50,48,46,44,42,40,38,36,34,32,30,28,26,24,22,20,18,16,14,12,10,8,6,4,2,0)
140 _SCCPOKE(&H988F,1)
150 _SCCPOKE(&H9880,253,0)
160 _SCCPOKE(&H988A,8)
170 _SCCPOKE(&H98E0,32)
170 _SCCPOKE(&H9880,253,0):GOTO 170
