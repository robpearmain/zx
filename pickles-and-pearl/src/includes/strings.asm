lives_message:
	defb 24,0,paper_black+ink_yellow,'LIVE','S'+128
	defb 128

lives:
	defb 30,0,paper_black+ink_yellow+attr_bright,'A',' '+128
	defb 128

items_left:
		defb 4,0,paper_black+ink_magenta,'RINGS REMAININ','G'+128,128

items:
		defb 1,0,attr_bright+paper_black+ink_magenta,'00',' '+128,128

redefine_message:
		defb 13,6,attr_bright+paper_black+ink_yellow,'REDEFIN','E'+128
		defb 12,8,%01000011,'LEF','T'+128
		defb 11,10,%01000011,'RIGH','T'+128
		defb 12,12,%01000011,'JUM','P'+128
		defb 128


menu_window:
		defb 7,5,20,11

menu_message:
		defb 8,4,attr_bright+paper_black+ink_cyan,'PICKLES AND PEAR','L'+128
		defb 14,6,attr_bright+paper_black+ink_yellow,'PLA','Y'+128
		defb 11,8,%01000100,'1. WORLD ','1'+128
		defb 11,10,%01000100,'2. WORLD ','2'+128
		defb 11,12,%01000100,'3. WORLD ','3'+128
		defb 11,14,%01000100,'4. WORLD ','4'+128
		defb 11,16,%01000100,'5. WORLD ','5'+128
		defb 15,18,%01000110,'O','R'+128
		defb 8,20,%01000011,'R. REDEFINE KEY','S'+128
		defb 128


energy_message:
		defb 13,23,attr_bright+paper_green+ink_white,'ENERG','Y'+128
		defb 128
