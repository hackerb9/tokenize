10 'This module was last updated 17-Sep-2000
10 'The official archive for PERIOD is http://nemesis.lonestar.org
10 CLEAR 200:CNT%=112:CR$=CHR$(13)+CHR$(10):DIM ELE$(CNT%):RESTORE 840:CLS
20 PRINT "Periodic Table Utility":PRINT "Version is 1(7) 7-Sep-2000 M100"
30 PRINT "Original Model 100 version, 1982": PRINT "Copr. 1982,1983,2000 Frank Durda IV"
40 PRINT "Ref: CRC Chemistry Ref, 52nd Edition":PRINT "Sargent-Welch Chemistry Tables 1980"
50 PRINT "Press <f1> or ?<Enter> for Help"
60 KEY 1,"Help"+CHR$(13):EL$="Element"
70 FOR T1%=1 TO CNT%:READ ELE$(T1%):NEXT T1%
80 LINE INPUT "Element? ";A$
90 IF LEN(A$)=0 THEN 80 ELSE A$=LEFT$(A$,15)
100 IF A$="?" THEN 220 ELSE GOSUB 440:IF B$="Help" THEN 220
110 GOSUB 440:IF B$="Menu" THEN MENU
120 A=VAL(A$):A%=A:IF A=0 THEN 280 ELSE IF A<0 THEN 80
130 IF A%<>A OR INSTR(1,A$,".")>0 OR A%>CNT% THEN 150
140 NM%=A%:SH$=ELE$(NM%):GOSUB 350:GOTO 80
150 C$=STR$(A):C%=INSTR(1,C$,"."):IF C%=0 THEN D%=0 ELSE D%=LEN(MID$(C$,C%+1,20))
160 GOSUB 270:FOR NM%=1 TO CNT%
170 SH$=ELE$(NM%):PP%=0:GOSUB 570:GOSUB 570
180 B=VAL(A$):IF B=0 THEN A$=MID$(A$,2,10):GOTO 180
190 B=INT(B*10^D%)/10^D%:IF A=B THEN GOSUB 350:GOTO 80
200 NEXT NM%
210 PRINT "Can't find that element":GOTO 80
220 CLS: PRINT "Command Formats Are:":PRINT "26     Displays ";EL$;" number 26"
230 PRINT "55.8   Displays the ";EL$;" with an":PRINT "       Atomic Weight of Approx 55.8"
240 PRINT "XENON  Displays the Element XENON":PRINT "W      Displays Element with that"
250 PRINT "       abbreviation (Tungsten)":PRINT "Press any key to continue";
260 A$=INKEY$:IF A$="" THEN 260 ELSE PRINT CHR$(13);"<f8>   Returns to main menu":GOTO 80
270 PRINT@263,"Searching...":RETURN
280 GOSUB 270:IF LEN(A$)<3 THEN 330 ELSE GOSUB 440
290 FOR NM%=1 TO CNT%:SH$=ELE$(NM%):C$=MID$(SH$,3,INSTR(3,SH$,"/")-3)
300 T1%=INSTR(1,C$,B$):T2%=INSTR(1,C$,"("+B$)
310 IF T1%=1 OR T2%>0 THEN GOSUB 350:GOTO 80
320 NEXT NM%:GOTO 210
330 GOSUB 440:B$=LEFT$(B$+" ",2):FOR NM%=1 TO CNT%
340 SH$=ELE$(NM%):IF LEFT$(SH$,2)=B$ THEN GOSUB 350:GOTO 80 ELSE NEXT NM%:GOTO 290
350 PP%=0:GOSUB 570:CLS:PRINT LEFT$(A$,2);" ";NM%;" ";MID$(A$,3,30);"  ";:GOSUB 570
360 PRINT A$:PRINT "Electron Distribution   Crystal"
370 PRINT "K  L  M  N  O  P  Q";TAB(23);"Structure":GOSUB 570:GOSUB 480
380 PRINT "Electronegativity ";:GOSUB 570
390 IF A$="" THEN PRINT "---" ELSE PRINT A$
400 GOSUB 570:CR%=VAL(A$):IF CR%>0 THEN GOSUB 590 ELSE T$="":PRINT@183,"Not Known":LINE(134,9)-(134,37),1
410 GOSUB 570:Y$="":Z%=INSTR(1,A$,"@"):IF Z%>0 THEN Y$=MID$(A$,Z%+1,40):A$=LEFT$(A$,Z%-1)
420 PRINT@200,;:IF VAL(LEFT$(A$,1))>0 THEN PRINT "Discovered in ";A$ ELSE PRINT A$
430 IF LEN(Y$)>0 THEN PRINT Y$
440 B%=ASC(LEFT$(A$,1)):IF B%>96 THEN B%=B%-32
450 B$=CHR$(B%):IF LEN(A$)=1 THEN RETURN ELSE FOR T1%=2 TO LEN(A$)
460 B%=ASC(MID$(A$,T1%,1)):IF B%<96 THEN B%=B%+32
470 B$=B$+CHR$(B%):NEXT T1%:RETURN
480 T1%=0:S%=0:D$="":Q$=""
490 T1%=T1%+1:T2%=T1%:T1%=INSTR(T1%,A$,",")
500 IF T1%>0 THEN X$=MID$(A$,T2%,T1%-T2%):Q$=Q$+LEFT$(X$+"  ",3):S%=S%+VAL(X$):GOTO 490 ELSE X$=MID$(A$,T2%):Q$=Q$+LEFT$(X$+"  ",3):S%=S%+VAL(X$)
510 R%=NM%-S%:IF R%>1 THEN D$="2  ":ELSE 560
520 IF R%=2 THEN 560 ELSE D$=D$+"8  "
530 IF R%=10 THEN 560 ELSE D$=D$+"18 "
540 IF R%=28 THEN 560 ELSE D$=D$+"32 "
550 IF R%=60 THEN 560 ELSE D$=D$+"32 "
560 PRINT LEFT$(D$+Q$+"-  -  -  -  -  -",20):RETURN
570 PP%=PP%+1:LP%=PP%:PP%=INSTR(PP%,SH$,"/"):IF PP%=0 THEN A$=MID$(SH$,LP%) ELSE A$=MID$(SH$,LP%,PP%-LP%)
580 RETURN
590 RESTORE 760
600 XF%=203:YF%=10:T$="":X$="":X1%=0
610 READ T1%,T2%,T3%,X$
620 FOR T4%=1 TO T2%+1:READ T8%,T9%:IF T1%=CR% AND T4%=1 THEN T$=X$
630 IF T1%<>CR% OR T4%=1 THEN 690
640 IF T8%<0 THEN READ T6%,T7%:T8%=ABS(T8%):VB%=-1:T4%=T4%+1 ELSE VB%=0
650 X1%=(T6%*4)+XF%:X2%=(T8%*4)+XF%:Y1%=(T7%*4)+YF%:Y2%=(T9%*4)+YF%
660 LINE (X1%,Y1%)-(X2%,Y2%),1:IF VB% THEN 700
670 X3%=((T6%+T3%)*4)+XF%:X4%=((T8%+T3%)*4)+XF%:Y3%=((T7%+7)*4)+YF%:Y4%=((T9%+7)*4)+YF%
680 LINE (X3%,Y3%)-(X4%,Y4%),1:LINE (X1%,Y1%)-(X3%,Y3%),1
690 T6%=T8%:T7%=T9%
700 NEXT T4%:IF X1%=0 THEN 610
710 T1%=143:T2%=1
720 T3%=INSTR(T2%,X$,"/")
730 IF T3%=0 THEN PRINT@T1%,MID$(X$,T2%,12);:LINE(134,9)-(134,37),1:RETURN
740 IF T3%-T2%<>0 THEN PRINT@T1%,MID$(X$,T2%,T3%-T2%);
750 T1%=T1%+40:T2%=T3%+1:GOTO 720
760 DATA 1,4,,"/  Cubic",3,,9,,7,2,1,2,3,
770 DATA 2,12,,"Cubic, Face/ Centered",3,,9,,7,2,1,2,3,,-4,5,4,6,-4,6,5,6,-5,6,5,5,-5,5,4,5
780 DATA 3,12,,"Cubic, Body/ Centered",3,,9,,7,2,1,2,3,,-3,,7,9,-9,,1,9,-3,7,7,2,-9,7,1,2
790 DATA 4,6,,"/ Hexagonal",1,1,4,,7,,8,1,5,2,2,2,1,1
800 DATA 5,4,-3,"/Rhombohedral",5,1,7,-1,8,2,6,4,5,1
810 DATA 6,4,,"/ Tetragonal",4,,8,,6,2,2,2,4,
820 DATA 7,4,,"/Orthorhombic",3,,8,,7,1,2,1,3,
830 DATA 8,4,2," /Monoclinic",1,,6,0,5,2,,2,1,
840 DATA "H Hydrogen/1.0079/1/2.2/4/1766 by Cavendish"
850 DATA "HeHelium/4.0026/2//1/1868 by Janssen"
860 DATA "LiLithium/6.941/1/.98/3/1817 by Arfvedson"
870 DATA "BeBeryllium/9.01218/2/1.57/4/1798 by Vauquelin"
880 DATA "B Boron/10.81/3/2.04/5/1808 by Davy"
890 DATA "C Carbon/12.011/4/2.55/4/Prehistoric Discovery"
900 DATA "N Nitrogen/14.0067/5/3.04/4/1772 by Rutherford"
910 DATA "O Oxygen/15.9994/6/3.44/8/1771 by Scheele"
920 DATA "F Fluorine/18.998403/7/3.98/8/1771 by Scheele.@Isolated by Moisson in 1886"
930 DATA "NeNeon/20.179/8//2/1898 by@Ramsay & Travers"
940 DATA "NaSodium/22.98977/1/.93/3/1807 by Davy"
950 DATA "MgMagnesium/24.305/2/1.31/4/1755@by Black"
960 DATA "AlAluminum/26.98154/3/1.61/2/1825@by Oerstead"
970 DATA "SiSilicon/28.0855/4/1.9/2/1824@by Berzelius"
980 DATA "P Phosphorus/30.97376/5/2.19/8/1669@by Brand"
990 DATA "S Sulfur/32.06/6/2.58/7/Refered to in Genesis@as Brimstone"
1000 DATA "ClChlorine/35.453/7/3.16/7/1774@by Scheele"
1010 DATA "ArArgon/39.948/8//2/1894@by Rayleigh & Ramsay"
1020 DATA "K Potassium/39.0983/8,1/.82/3/1807@by Davy"
1030 DATA "CaCalcium/40.08/8,2/1/2/1808@by Davy"
1040 DATA "ScScandium/44.9559/9,2/1.36/4/1876@by Nilson"
1050 DATA "TiTitanium/47.90/10,2/1.54/4/1791@by Gregor"
1060 DATA "V Vanadium/50.9415/11,2/1.63/3/1801@by del Rio"
1070 DATA "CrChromium/51.996/13,1/1.66/3/1790@by Vauquelin"
1080 DATA "MnManganese/54.9380/13,2/1.55/3/1770 by Kaim.@Isolated by Gahn in 1774"
1090 DATA "FeIron/55.847/14,2/1.83/3/Mentioned in Genesis@Tubal-Cain worked Iron"
1100 DATA "CoCobalt/58.9332/15,2/1.88/4/1735@by Brandt"
1110 DATA "NiNickel/58.70/16,2/1.91/2/China used in coins, 235BC.@Purified in 1751 by Cronstedt"
1120 DATA "CuCopper/63.546/18,1/1.9/2/Prehistoric Discovery"
1130 DATA "ZnZinc/65.38/18,2/1.65/4/Prehistoric Discovery"
1140 DATA "GaGallium/69.72/18,3/1.81/7/1875 by@Lecoq de Boisbaudran"
1150 DATA "GeGermanium/72.59/18,4/2.01/2/1886@by Winkler"
1160 DATA "AsArsenic/74.9216/18,5/2.18/5/1250@by Albertus Magnus"
1170 DATA "SeSelenium/78.96/18,6/2.55/4/1817@by Berzelius"
1180 DATA "BrBromine/79.904/18,7/2.96/7/1826@by Balard"
1190 DATA "KrKrypton/83.80/18,8//2/1898 by@Ramsay & Travers"
1200 DATA "RbRubidium/85.4678/8,1/.82/3/1861 by@Bunsen & Kirchoff"
1210 DATA "SrStrontium/87.62/8,2/.95/2/1790 by Crawford.@Metal form 1807 by Davy"
1220 DATA "Y Yttrium/88.9059/9,2/1.22/4/1794@by Gadolin"
1230 DATA "ZrZirconium/91.22/10,2/1.33/4/1789@by Klaproth"
1240 DATA "NbNiobium (Columbium)/92.9064/12,1/1.6/3/1801@by Hatchett"
1250 DATA "MoMolybdenum/95.94/13,1/2.16/3/1778@by Scheele"
1260 DATA "TcTechnetium (Masurium)/(98)/14,1/1.9/4/1937 by@Perrier & Segr`e"
1270 DATA "RuRuthenium/101.07/15,1/2.2/4/1827 by@Berzelius & Osann"
1280 DATA "RhRhodium/102.9055/16,1/2.28/2/1803-4@by Wollaston"
1290 DATA "PdPalladium/106.4/18/2.2/2/1803@by Wollaston"
1300 DATA "AgSilver/107.868/18,1/1.93/2/Mentioned in Genesis"
1310 DATA "CdCadmium/112.41/18,2/1.69/4/1817@by Strohmeyer"
1320 DATA "InIndium/114.82/18,3/1.78/6/1863 by@Reich & Richter"
1330 DATA "SnTin/118.69/18,4/1.96/6/Known to the ancients"
1340 DATA "SbAntimony/121.75/18,5/2.05/5/Known as a metal in@the early 17th century"
1350 DATA "TeTellurium/127.60/18,6/2.1/4/1782 by@Baron von Reichenstein"
1360 DATA "I Iodine/126.9045/18,7/2.66/7/1811@by Courtois"
1370 DATA "XeXenon/131.30/18,8//2/1898 by@Ramsay & Travers"
1380 DATA "CsCesium/132.9054/18,8,1/.79/3/1860 by@Bunsen & Kirchhoff"
1390 DATA "BaBarium/137.33/18,8,2/.89/3/1774 by Scheele.@Pure metal 1808 by Davy"
1400 DATA "LaLanthanum/138.9055/18,9,2/1.1/4/1839@by Mosander"
1410 DATA "CeCerium/140.12/20,8,2/1.12/2/1803 by@Klaproth, Berzelius & Hisinger"
1420 DATA "PrPraseodymium/140.9077/21,8,2/1.13/4/1885@by von Welsbach"
1430 DATA "NdNeodymium/144.24/22,8,2/1.14/4/1885@by von Welsbach"
1440 DATA "PmPromethium/(145)/23,8,2/1.13/4/1926 by Harris,@Hopkins, Rolla and Fernando."
1450 DATA "SmSamarium/150.4/24,8,2/1.17/5/1879@by Lecoq de Boisbaudran"
1460 DATA "EuEuropium/151.96/25,8,2/1.2/3/1901@by Demarcay"
1470 DATA "GdGadolinium/157.25/25,9,2/1.2/4/1880 by@Marignac & Lecoq de Boisbaudran"
1480 DATA "TbTerbium/158.9254/27,8,2/1.2/4/1843@by Mosander"
1490 DATA "DyDysprosium/162.50/28,8,2/1.22/4/1886 by@Lecoq de Boisbaudran"
1500 DATA "HoHolmium/164.9304/29,8,2/1.23/4/1878 by@Per Cleve"
1510 DATA "ErErbium/167.26/30,8,2/1.24/4/1842 by@Mosander"
1520 DATA "TmThulium/168.9342/31,8,2/1.25/4/1879@by Cleve"
1530 DATA "YbYtterbium/173.04/8,2/1.1/2/1878@by Marignac"
1540 DATA "LuLutetium/174.967/9,2/1.27/4/1907 by@Urbain, von Welsbach & James"
1550 DATA "HfHafnium/178.49/10,2/1.3/4/1923 by@D. Coster & G. von Hevesey"
1560 DATA "TaTantalum/180.9479/11,2/1.5/3/1802@by Ekeberg"
1570 DATA "W Tungsten (Wolfram)/183.85/12,2/2.36/3/1779@by Peter Woulfe"
1580 DATA "ReRhenium/186.207/13,2/1.9/4/1925 by@Noddack, Tacke & Berg"
1590 DATA "OsOsmium/190.2/14,2/2.2/4/1803@by Tennant"
1600 DATA "IrIridium/192.22/15,2/2.2/2/1803@by Tennant"
1610 DATA "PtPlatinum/195.09/17,1/2.28/2/1735 by@Ulloa & 1741 by Wood"
1620 DATA "AuGold/196.9665/18,1/2.54/2/Known and valued@from earliest times"
1630 DATA "HgMercury/200.59/18,2/2/5/Known to ancient@Chinese & Hindus"
1640 DATA "TlThallium/204.37/18,3/2.04/4/1861@by Crookes"
1650 DATA "PbLead/207.2/18,4/2.33/2/Long known;@Mentioned in Exodus"
1660 DATA "BiBismuth/208.9804/18,5/2.02/5/1753 by@Claude Geoffroy the Younger"
1670 DATA "PoPolonium/(209)/18,6/2/8/1898@by Mme. Curie"
1680 DATA "AtAstatine/(210)/18,7/2.2//1940 by@D.R. Corson, K.R. Mackenzie & E. Segr"
1690 DATA "RnRadon (Niton)/(222)/18,8//2/1900@by Dorn"
1700 DATA "FrFrancium/(223.0197)/18,8,1/.7/3/1939 by@Mlle. Marguerite Perey"
1710 DATA "RaRadium/226.0254/18,8,2/.9/3/1898 by@M. and Mme. Curie"
1720 DATA "AcActinium/227.0278/18,9,2/1.1/2/1899 by@Andre Debierne & 1902 by F. Giesel"
1730 DATA "ThThorium/232.03804/18,10,2/1.3/2/1828@by Berzelius"
1740 DATA "PaProtactinium/231.0359/20,9,2/1.5/7/1913@by K. Fajans & O. H. Gohring"
1750 DATA "U Uranium/238.029/21,9,2/1.38/7/Found in glass dated@about 79AD. Isolated in 1841 by Peligot"
1760 DATA "NpNeptunium/237.0482/23,8,2/1.36/7/1940@by McMillan & Abelson"
1770 DATA "PuPlutonium/(244)/24,8,2/1.28/8/1940 by@Seaborg, McMillan, Kennedy & Wahl"
1780 DATA "AmAmericium/(243)/25,8,2/1.3/4/1944 by@Seaborg, James, Morgan & Ghiorso"
1790 DATA "CmCurium/(247)/25,9,2/1.3//1944 by@Seaborg, James & Ghiorso"
1800 DATA "BkBerkelium/(247)/26,9,2/1.3//1949 by@Thompson, Ghiorso & Seaborg"
1810 DATA "CfCalifornium/(251)/29,8,2/1.3//1950 by@Thompson, Street, Ghiorso & Seaborg"
1820 DATA "EsEinsteinium/(252)/29,8,2/1.3//1952 in@debris of first H-bomb explosion"
1830 DATA "FmFermium/(257)/30,8,2/1.3//1952 in@debris of first H-bomb explosion"
1840 DATA "MdMendelevium/(258)/31,8,2/1.3//1955 by@Ghiorso, Harvey, Choppin & Thompson"
1850 DATA "NoNobelium/(259)/8,2/1.3//1958 by@Ghiorso, Sikkeland, Walton & Seaborg"
1860 DATA "LrLawrencium/(260)/9,2///1961 by@Ghiorso, Sikkeland, Larsh & Latimer"
1870 DATA "RfRutherfordium/(261)/10,2///1964 by Berkeley & Dubna."
1880 DATA "DbDubnium/(262)/11,2///1970 by Ghiorso"
1890 DATA "SgSeaborgium/(263)/12,2///by Ghiorso"
1900 DATA "BhBohrium/(264)/13,2///1981 by@Armbruster and Munzenberg"
1910 DATA "HsHassium/(265)/14,2///1983 by@Armbruster and Munzenberg"
1920 DATA "MtMeitnerium/(266)/15,2///1984 by@Armbruster and Munzenberg"
1930 DATA "--Element 110/(269)/17,1///1994 by Hofmann, Ninov,@Hessberger and others"
1940 DATA "--Element 111/(272)/18,1///1994 by Hofmann, Ninov,@Hessberger and others"
1950 DATA "--Element 112/(277)/18,2///Single atom made in 1996 by@Armbruster and Munzenberg"
