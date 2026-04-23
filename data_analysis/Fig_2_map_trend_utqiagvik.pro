pro map_trnd_utqiagvik,cf,ff,iind,alat,alon,perxy,plttit,psname

; map_trnd_utqiagvik,acf8,aff8,1,alats,alons,perxy2,'Ice-Edge Retreat Trend','uretmap_trnd7923.ps'

; map_trnd_utqiagvik,acf8,aff8,0,alats,alons,perxy2,'Ice-Edge Advance Trend','uadvmap_trnd7923.ps'

; map_trnd_utqiagvik,acf8,aff8,2,alats,alons,perxy2,'Ice Season Duration Trend','udurmap_trnd7923.ps'

; restore,'../Savs/ao_trnd7923.sav
; restore,'../Savs/ao_latlon.sav
; restore,'../Savs/ao_perxy2.sav

; set font
window,1
plot,indgen(10),/nodata
xyouts,0,0,'!17foo'
wdelete,1



pos=[0.2,0.27,0.8,0.73]

; region map limits
rslims=[55,180,85,240]

cind=where(perxy eq 2)
cper=bytarr(304,448)
cper(cind)=1

;ac=cf(7:302,70:370,iind)
;af=ff(7:302,70:370,iind)
;alts=alat(7:302,70:370)
;alns=alon(7:302,70:370)
;cpr=cper(7:302,70:370)

ac=cf(*,*,iind)
af=ff(*,*,iind)
alts=alat
alns=alon
cpr=cper

;IDL> print,f_cvf(0.01,1,22)
fcut=7.9

; map labels, 55-90N, 90W-180W to 150E
lns=[130,140,150,160,170,180,190,200,210,220,230,240,250,260,270,280,290]
lnnms=[' ',' ',' ','160E',' ',' ',' ','160W',' ',' ',' ','120W',' ',' ',' ',' ',' ']
lts=[45,50,55,60,65,70,75,80,85,90]
ltnms=[' ',' ',' ','60N',' ','70N','75N',' ',' ',' ']

toggle,/color,filename=psname
!p.charsize=1.0

; adv/ret/dur trend 
map_set,70,210,/stereo,limit=rslims,$
  position=pos(*,0),/noe,/nob

tice=ac
nind=where(tice le -999.)
tice(nind)=0.
newsic = map_patch(tice,alns,alts)
newff = map_patch(af,alns,alts)
newcp = map_patch(cpr,alns,alts)

loadct,78,file='~/idl/my_lib/colors1.tbl'
if (iind lt 2) then $
  tvim,newsic,range=[-2.4,2.4,0.3],/noa,position=pos,$
    barwidth=0.5,title=plttit,scale=2,$
    stitle='Later                  (days/yr)                  Earlier'
if (iind eq 2) then $
  tvim,newsic,range=[-4,4],/noa,position=pos,$
    barwidth=0.5,title=plttit,scale=2,$
    stitle='Longer                 (days/yr)                  Shorter'

;loadct,74,file='~/idl/my_lib/colors1.tbl'
;if (iind lt 2) then $
;  tvim,newsic,range=[-2,2],/noa,position=pos,$
;    barwidth=0.5,title=plttit
;if (iind eq 2) then $
;  tvim,newsic,range=[-3,3],/noa,position=pos,$
;    barwidth=0.5,title=plttit


; contour every 0.5 increment from -2.0 to 2.0
;lvc=-1.5
;for j=0,7 do begin
;  contour,/over,newsic,lev=lvc,col=0,c_thi=2
;  lvc=lvc+0.5
;endfor

; contour the perennial pack ice extent
;contour,/over,newcp,lev=1,col=0,c_thi=2

; contour the p=0.01 sig leve
;contour,newff,lev=fcut,/over,c_li=1,thick=5

loadct,0
map_set,70,210,/stereo,limit=rslims,$
  position=pos(*,0),/nob,/noe,/hires
map_continents,/fill_cont,color=150
map_continents,/cont,color=0,mlinethick=3
map_grid,/label,lonlab=80,latlab=-170,latdel=5,londel=10,$
  lonnames=lnnms,lons=lns,latnames=ltnms,lats=lts
;map_grid,color=0,label=1,lats=lts,latnames=ltnms,lons=lns,lonnames=lnnms,$
;    latlab=-170,lonlab=80,clip_text=0,glinestyle=0,charsize=0.8


; create 5-pointed star symbol
 theta = findgen(11) * 2.0 * !PI / 5.0 + !PI/2.0
 r = fltarr(11)
 r[2*indgen(6)] = 1.0  ; Outer radius
 r[2*indgen(5)+1] = 0.4 ; Inner radius
 x = r * cos(theta)
 y = r * sin(theta)
 usersym, x, y, /fill
; plot, findgen(10), findgen(10), psym=8, symsize=2

; overlay star symbol to indicate Utqiagvik
loadct,0
if (iind eq 0) then oplot,[-157.79],[71.29],psym=8,col=0,symsize=2
if (iind gt 0) then oplot,[-157.79],[71.29],psym=8,col=0,symsize=2
;xyouts,-157.7887,71.2905,'*',/data,charsize=2

;loadct,74,file='~/idl/my_lib/colors1.tbl'
;if (iind lt 2) then begin
;   colorbarn,0.2,0.21,0.8,0.22,-2,2,1.1
;   xyouts,0.5,0.17,/norm,align=0.5,'Earlier           (days/year)             Later'
;endif

;if (iind eq 2) then begin
;   colorbarn,0.2,0.21,0.8,0.22,-3,3,1.1
;   xyouts,0.5,0.17,/norm,align=0.5,'Shorter            (days/year)             Longer'
;endif

toggle

!p.multi=0
!p.charsize=1.
loadct,0
end
