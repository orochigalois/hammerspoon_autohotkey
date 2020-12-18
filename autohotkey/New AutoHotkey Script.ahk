Progress, m1 b fs20 zh0 w200, Enter # of minutes
loop,2
	{
	Input x, L1,{enter}{esc},1,2,3,4,5,6,7,8,9,0
	if (ErrorLevel = "Match")
		Progress, m1 b fs70 fm12 zh10 w200, % tm .= x, Press Enter to accept
	else if (Errorlevel = "EndKey:enter")
		break
	else
		exitapp
	}
settimer,label,1000
label:
++y
Progress, % 100*(tm*60-y)/(tm*60), % tm-floor(y/60)-1, % y>tm*60 ? tm*60-y : ((z:=mod(tm*60-y,60))=0 ? 60 : z)
if (y = tm * 60)
	Progress, m1 b fs40 fm20 zh0 CTred w200, , done
esc::
exitapp