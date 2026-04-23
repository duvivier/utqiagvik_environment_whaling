pro plt_utq_ts,a7924,iind,psname

; plt_utq_ts,a7924,0,'utqiagvik_DOA_ts.ps'

; restore,'../Savs/ao_a7924t.sav

; set font
plot,indgen(10),/nodata
xyouts,0,0,'!17foo'
wdelete

; satellite pixel for Utqiagvik
x=77
y=245

yrs=indgen(180)+1920
pos=[0.15,0.3,0.9,0.7]

; legend placement
;if (iind eq 0) then begin
;  p2a=[0.70,0.25,0.95,0.35]
;  p2b=[0.70,0.20,0.95,0.30]
;  p2c=[0.70,0.15,0.95,0.25]
;  p2d=[0.70,0.10,0.95,0.20]
;  p2e=[0.70,0.05,0.95,0.15]
;endif

if (iind eq 1) then begin
   p2a=[0.10,0.25,0.35,0.35]
   p2b=[0.10,0.20,0.35,0.30]
   p2c=[0.10,0.15,0.35,0.25]
   p2d=[0.10,0.10,0.35,0.20]
   p2e=[0.10,0.05,0.35,0.15]
endif



lr=[240,450,0]
ur=[450,630,370]
ytit=['Day of Year','Day of Year','Days']
ptit=['Day of Advance','Day of Retreat','Ice Season Duration']

if (iind eq 0) then var='DOA'
if (iind eq 1) then var='DOR'
if (iind eq 2) then var='ice_season'

toggle,/color,/portrait,filename=psname

!p.charsize=1.2
!p.thick=5
;xgridstyle=1,ygridstyle=1,xticklen=1,yticklen=1

 filename='Model_data/cesm1le_Utqigvik_1920-2100_ice_statistics.nc'
 id=NCDF_open(filename)
 idd=NCDF_VARID(id,var)
 NCDF_VARGET,id,idd,mvar

 ; CESM1le is red
 loadct,9,file='~/idl/my_lib/colors1.tbl
 plot,yrs,mvar,min_val=0,/xstyle,xtitle='Year',ytitle=ytit(iind),$
	position=pos,/ystyle,yrange=[lr(iind),ur(iind)],title=ptit(iind),$
	/nodata
 oplot,yrs,mvar,col=1

 ; CESM2le is blue
 filename='Model_data/cesm2le_Utqigvik_1920-2100_ice_statistics.nc'
 id=NCDF_open(filename)
 idd=NCDF_VARID(id,var)
 NCDF_VARGET,id,idd,mvar

 ; loadct,9,file='~/idl/my_lib/colors1.tbl
 oplot,yrs,mvar,col=5

 ; CESM2CMIP4 is gold
 filename='Model_data/cesm2cmip5_Utqigvik_1920-2100_ice_statistics.nc
 id=NCDF_open(filename)
 idd=NCDF_VARID(id,var)
 NCDF_VARGET,id,idd,mvar

 loadct,5
 oplot,yrs,mvar,col=170

 ; MESACLIP is purple
 filename='Model_data/mesaclip_Utqigvik_1920-2100_ice_statistics.nc
 id=NCDF_open(filename)
 idd=NCDF_VARID(id,var)
 NCDF_VARGET,id,idd,mvar

 loadct,12
 oplot,yrs,mvar,col=120

 ; Observations are black
 loadct,0,file='~/idl/my_lib/colors1.tbl
 oplot,yrs(59:103),a7924(x,y,*,iind),min_val=0

 if (iind eq 1) then begin
   loadct,9,file='~/idl/my_lib/colors1.tbl
   legend,['CESM1 le   '],col=1,pos=p2a  ; red
   legend,['CESM2 le   '],col=5,pos=p2b  ; blue
   loadct,5
   legend,['CESM2 CMIP5'],col=170,pos=p2c  ; gold
   loadct,12
   legend,['MESACLIP   '],col=120,pos=p2d  ; purple
   loadct,0
   legend,['Sat Obs    '],col=0,pos=p2e  ; black
 endif

toggle


!p.charsize=1
!p.thick=1
end
