*Project "Folded cascode Op amp with gain boosting"
.prot
.lib 'cmos_1u.l' mos
.unprot
.options post ingold=2
.param lmin=0.5u fin=120k Tin='1/fin' offset=35m
.global dd gnd


***********************auxopamp circuit for gain boosting********
.subckt auxopamp    bias  input+  input-     o+  o- 

M1    o+   input-   s12  gnd  NMOS    W='7*lmin'     l='5*lmin'
M2    o-   input+   s12  gnd  NMOS    W='7*lmin'     l='5*lmin'
Mp1   o+   o+       dd   dd   PMOS    W='21*lmin'    l='5*lmin'
Mp2   o-   o+       dd   dd   PMOS    W='21*lmin'    l='5*lmin'
Mbias s12  bias     gnd  gnd  NMOS    W='7*lmin'     l='5*lmin'

.ends auxopamp

************************* circuit

M11   d11     i+      s112   gnd   nmos   W='30.324*lmin'  l='5*lmin'
M12   d12     i-      s112   gnd   nmos   W='30.324*lmin'  l='5*lmin'
M13   s112    bias3   s13    gnd   nmos   W='30.324*lmin'  l='5*lmin'
M14   s13     bias4   gnd    gnd   nmos   W='15*lmin'      l='5*lmin'
M15   d12     cmfb    dd     dd    pmos   W='576*lmin'     l='4*lmin'
M16   d11     cmfb    dd     dd    pmos   W='576*lmin'     l='4*lmin'
M17   out-    g17     d11    dd    pmos   W='355*lmin'     l='4*lmin'
M18   out+    g18     d12    dd    pmos   W='355*lmin'     l='4*lmin'
M19   out-    g19     s19    gnd   nmos   W='30.324*lmin'  l='5*lmin'
M20   out+    g20     s20    gnd   nmos   W='30.324*lmin'  l='5*lmin'
M21   s19     bias4   gnd    gnd   nmos   W='40*lmin'      l='5*lmin'
M22   s20     bias4   gnd    gnd   nmos   W='40*lmin'      l='5*lmin'

********
Xaxuopamp1   bias2  d11   d12  g17  g18   auxopamp

Xaxuopamp3   bias3  s19   s20  g19  g20   auxopamp

Cload-	out-	gnd     5pF
Cload+	out+	gnd	5pF

c17 g17 gnd 3pf
c18 g18 gnd 3pf
c19 g19 gnd 3pf
c20 g20 gnd 3pf

********************************biasing circuit

Mb1  dd  b1  b1  dd  pmos  W='59.712U'   l='4*lmin'
Mb3  dd  b1  b3  dd  pmos  W='59.712U'   l='4*lmin'

Mb2  b1  bi2 bi2 dd  pmos  W='59.712U'   l='4*lmin'
Mb4  b3  bi2 b4  dd  pmos  W='59.712U'   l='4*lmin'

Mb5  b4  b4  bi3 0   nmos  W='37U'       l='16*lmin'
Mb6  bi3 bi3 0   0   nmos  W='37U'       l='4*lmin'

Mb7  dd  b4  bi4 0   nmos  W='37U'       l='4*lmin'
Mb8  bi4 bi3 0   0   nmos  W='37U'       l='4*lmin'
ebias2   bias2  gnd  bi2 0 1
ebias3   bias3  gnd  bi4 0 1
ebias4   bias4  gnd  bi3 0 1


*********CMFB circuit
e1 x y out- 0 0.5
e2 y z out+ 0 0.5 
vcmo z 0 dc -2.5
vbn cmfb w dc 0.5
eout vout 0 vol='v(out-)-v(out+)-offset'
e3 w 0 x 0 3 
**************************** supply

Vdd   dd   gnd  5v
id    bi2  0    49.74u


Vi-	i-	gnd	sin	2	1m	fin
Vi+	i+	gnd	sin	2	-1m	fin 

*Vi+	i+	gnd     2  ac=1m  0
*Vi-	i-	gnd     2  ac=1m  180

******************************circuit analysis

*.ac dec 1000  1 1g
.tran	'10*Tin'	'12*Tin' start='2*Tin'

*.meas ac gain find par'vdb(vout)' at 1
*.meas ac ft when vdb(out+)=0
*.meas ac ph find vp(out+) at=ft 
*.meas ac pm param'180+ph'
.plot V(vout)
.op
.probe
.end