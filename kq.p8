pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--kaitlyn's quest
--by froxle

anims={
	idlef={fr=8,64,64,64,64,64,64,64,65},
	idleb={fr=8,97},
	idles={fr=8,81,81,81,81,81,81,81,66},
	idledf={fr=8,69,69,69,69,69,69,69,67},
	idledb={fr=8,113},
	walkf={fr=5,84,85,86,87},
	walkb={fr=5,96,97,98,99},
	walks={fr=5,80,81,82,83},
	walkdf={fr=5,68,69,70,71},
	walkdb={fr=5,112,113,114,115},
	fire0={fr=2,208,224,240,198},
	idle0={fr=1,208}
}
bul_rot={}

--firepats={
--	dual={
--		i={"f","b","s","sf"},
--		f={"df","dff","db","dbf"}
--	},
--	horiz={
--		i={"f","b","s","sf"},
--	},
--	diag={
--		i={"df","dff","db","dbf"}
--	},
--	horizord={
--		i={"f"},
--		o={"b"},
--		x={"s"},
--		f={"sf"}
--	},
--	diagord={
--		i={"df"},
--		o={"dff"},
--		x={"db"},
--		f={"dbf"}
--	}
--}
firepats={
	h={"f","b","s","sf"},
	d={"df","dff","db","dbf"}
--	f={"f"},
--	b={"b"},
--	s={"s"},
--	sf={"sf"},
--	df={"df"},
--	dff={"dff"},
--	db={"db"},
--	dbf={"dbf"}
}
function _init()
	obl={}
	buls={}
	swrdl={}
	parryl={}
	eneml={}
	gates={}
	angles={0,45,90,135,180,225,270,315}
	st_inx=246
	for x=1,#angles do
		local d_inx=st_inx+x-1
		precomputeb(192,angles[x],d_inx,1,1)
		bul_rot[angles[x]]=d_inx
	end
	for x=0,127 do
		for y=0,31 do
			local spid = mget(x,y)
			if fget(spid,2) then
				add(gates,{x=x,y=y,open=false})
			end
		end
	end
	r0gates=false
	showui=false
	speed=3
	bulspd=3
	ftimer=0
	stimer=0
	ptimer=0
	room="start"
	lev="0"
	c0=false
	c1=false
	c2=false
	hi=7
	med=13
	lo=1
	hc=hi
	player={
		x=63,
		y=64,
		w=4,
		h=8,
		sp=64,
		f=false,
		spdx=0,
		spdy=0,
		cm=true,
		cw=false,
		dir="f",
		talking=false,
		weapon="gun",
		hp=10,
		mhp=10,
		drawp=drawo,
		update=updateplayer
	}
	player.play="idlef"
	james={
		name="jAMES",
		x=27*8,
		y=4*8,
		w=12,
		h=12,
		sp=103,
		f=false,
		talked=true,
		lines={
			"gOOD MORNING!",
			"hM? wHAT'S THAT? wHERE'S YOUR SISTER?",
			"uHHHH... THE BOTS TOOK HER...",
			"yEAH, i KNOW, i'M REALLY SORRY.",
			"sHE WENT OUT FOR A SCAVENGING RUN AND GOT INTO SOME HOT WATER. tHEN HER COMMS WENT SILENT, AND WE HAVEN'T HEARD FROM HER SINCE.",
			"wHAT?!?!? yOU CAN'T GO AFTER HER! iT'S TOO DANGEROUS!",
			"yOU DON'T KNOW HOW TO FIGHT!",
			"*SIGH* fINE, i CAN TELL YOUR MIND'S MADE UP. tALK TO aPRIL ABOUT THE FIGHTING THING, YOU KNOW HOW GOOD SHE IS AT TEACHING THAT KINDA STUFF.",
			"gOOD LUCK!"
		},
		linesa={
			"c'MON, GET GOING!",
			"yOU'VE GOT NO TIME TO LOSE!"
		},
		draw=drawo,
		update=updatenpc,
	}
	april={
		name="APRIL",
		x=19*8,
		y=26.5*8,
		w=12,
		h=12,
		sp=102,
		f=false,
		talked=true,
		lines={
			"HEY",
			"HOW YOU DOING",
			"YOURE LEAVING? NOW?",
			"I KNOW THEY TOOK YOUR SISTER BUT CMON ITS DANGEROUS... YOU ARENT EXPERIENCED IN COMBAT",
			"YOU WANT ME TO TEACH YOU HOW TO FIGHT???",
			"UHM",
			"UGH FINE ILL TELL YOU",
			"GOOD TO KNOW ANYWAY I GUESS",
			"USE 🅾️ TO SWAP WEAPONS AND USE ❎ TO USE THAT WEAPON",
			"SWITCHING WEAPONS ALSO PARRIES ANY RED ATTACKS",
			"REALLY ALL YOU NEED TO KNOW, I WOULD TELL YOU HOW TO FIGHT THE BOTS YOULL ENCOUNTER BUT THEY TEND TO CHANGE AROUND A LOT SO THERES NO WAY TO TELL WHAT THEYLL BE NOW...",
			"GOOD LUCK."
		},
		linesa={
			"DONT DIE OK?",
			"FOR A REFRESHER, ❎ ATTACK AND 🅾️ TO SWAP/PARRY",
			"GOODLUCK"
		},
		draw=drawo,
		update=updatenpc
	}
	joseline={
		name="joseline",
		x=10*8,
		y=24*8,
		w=14,
		h=14,
		sp=116,
		f=false,
		talked=true,
		lines={
			"hm? you want me to open the gates?",
			"sorry, no can do.",
			"kaitlyn, i know your sister is out there, but i can't risk it.",
			"look at us! we have 4 people now because your sister is gone! we used to have 30!",
			"no, i will not give you my respawn anchor. and i'm not letting you out of these gates.",
			"yes, i know, i know. if we get her back then we'll have 5 people instead of 4. i know.",
			"but if we lose you, then we'll be down to 3.",
			"yes, i still believe the rescue team is coming, i have to!",
			"okay, so let's say theoretically i do give you my respawn anchor. how will we protect ourselves if we get invaded while you are out?",
			"...",
			"you don't even know how to fight??",
			"*sigh* you know what? fine.",
			"i guess it'd be better to have 5 pairs of hands instead of 4...",
			"i'll open the gates when you talk to james and april.",
			"just get her back in one piece, okay?",
			"good luck."
		},
		linesa={
			"get to it."
		},
		draw=drawo,
		update=updatenpc
	}
	add(obl,james)
	add(obl,april)
	add(obl,joseline)
	camx=0
	camy=0
	w=250
	h=250
	doords={
		x,
		y
	}
	alertext={
		text="",
		x=0,
		y=0,
		col=2,
		col2=0,
		col3=1,
		col4=6
	}
end

function _update()
	if room=="start" then
		updates()
	elseif room=="game" then
		updateg()
	elseif room=="end" then
		updatee()
	end
end

function _draw()
	if room=="start" then
		draws()
	elseif room=="game" then
		drawg()
	elseif room=="end" then
		drawe()
	else
		print("TF HOW")
	end
end
-->8
--general functions
--flags 3, 6, and 7 are free

function col0(o)
  local ct=false
  local cb=false

  -- if colliding with map tiles
  if(o.cm) then
    local x1=(o.x+2)/8
    local y1=(o.y+4)/8
    local x2=(o.x+5)/8
    local y2=(o.y+7)/8
    local a=fget(mget(x1,y1),0)
    local b=fget(mget(x1,y2),0)
    local c=fget(mget(x2,y2),0)
    local d=fget(mget(x2,y1),0)
    ct=a or b or c or d
   end
   -- if colliding world bounds
   if(o.cw) then
   	cb=(o.x<0 or o.x+8>w or o.y<0 or o.y+8>h)
   end

  return ct or cb
end

function col1(o)
  local ct=false
  -- if colliding with door
  if(o.cm) then
    local x1=(o.x)/8
    local y1=(o.y)/8
    local x2=(o.x+7)/8
    local y2=(o.y+8)/8
    local a=fget(mget(x1,y1),1)
    local b=fget(mget(x1,y2),1)
    local c=fget(mget(x2,y2),1)
    local d=fget(mget(x2,y1),1)
    ct=a or b or c or d
    if a then
    	doords.x=x1
    	doords.y=y1
    elseif b then
    	doords.x=x1
    	doords.y=y2
    elseif c then
    	doords.x=x2
    	doords.y=y2
    elseif d then
    	doords.x=x2
    	doords.y=y2
    end
   end
  return ct
end

function col4(o)
  ct=false
  -- if colliding gate close
  if(o.cm) then
    local x1=o.x/8
    local y1=o.y/8
    local x2=(o.x+7)/8
    local y2=(o.y+7)/8
    local a=fget(mget(x1,y1),4)
    local b=fget(mget(x1,y2),4)
    local c=fget(mget(x2,y2),4)
    local d=fget(mget(x2,y1),4)
    local ac=mget(x1,y1)
    local bc=mget(x1,y2)
    local cc=mget(x2,y2)
    local dc=mget(x2,y1)
    if ac==129 then
    	mset(x1,y1,32)
    elseif ac==128 then
    	mset(x1,y1,4)
    end
    if bc==129 then
    	mset(x1,y2,32)
    elseif bc==128 then
    	mset(x1,y2,4)
    end
    if cc==129 then
    	mset(x2,y2,32)
    elseif cc==128 then
    	mset(x2,y2,4)
    end
    if dc==129 then
    	mset(x2,y1,32)
    elseif dc==128 then
    	mset(x2,y1,4)
    end
    ct=a or b or c or d
   end
  return ct
end

function col5(o)
  ct=false
  -- if colliding gate open
  if(o.cm) then
    local x1=o.x/8
    local y1=o.y/8
    local x2=(o.x+7)/8
    local y2=(o.y+7)/8
    local a=fget(mget(x1,y1),5)
    local b=fget(mget(x1,y2),5)
    local c=fget(mget(x2,y2),5)
    local d=fget(mget(x2,y1),5)
    local ac=mget(x1,y1)
    local bc=mget(x1,y2)
    local cc=mget(x2,y2)
    local dc=mget(x2,y1)
    if ac==132 then
    	mset(x1,y1,32)
    elseif ac==131 then
    	mset(x1,y1,4)
    end
    if bc==132 then
    	mset(x1,y2,32)
    elseif bc==131 then
    	mset(x1,y2,4)
    end
    if cc==132 then
    	mset(x2,y2,32)
    elseif cc==131 then
    	mset(x2,y2,4)
    end
    if dc==132 then
    	mset(x2,y1,32)
    elseif dc==131 then
    	mset(x2,y1,4)
    end
    ct=a or b or c or d
   end
  return ct
end

function opendoor()
	local x = doords.x
	local y = doords.y
	swaptile(x,y,1)
end

function col6(o)
  local ct=false

  -- if colliding with water tiles
  if(o.cm) then
    local x1=(o.x+2)/8
    local y1=(o.y+4)/8
    local x2=(o.x+5)/8
    local y2=(o.y+7)/8
    local a=fget(mget(x1,y1),6)
    local b=fget(mget(x1,y2),6)
    local c=fget(mget(x2,y2),6)
    local d=fget(mget(x2,y1),0)
    ct=a or b or c or d
   end

  return ct
end

function swaptile(x,y,flg)
	local check = fget(mget(x,y),flg)
	if check then
		tile=mget(x,y)
		mset(x,y,tile+1)
	end
end

function unswaptile(x,y)
	local check = fget(mget(x,y),flg)
	if check then
		tile=mget(x,y)
		mset(x,y,tile-1)
	end
end

function alerttext(text,x,y,col,col2,col3,col4)
	alertext.text=text
	alertext.x=x
	alertext.y=y
	alertext.col=col
	alertext.col2=col2
	alertext.col3=col3
	alertext.col4=col4
end

function animate(p)
	if p.state != p.play then --start a new animation
		p.state = p.play
		p.animindex = 1 --start with the first frame in the animation table
		p.time = 0  --reset the timer
	elseif #anims[p.state] > 1 then --continue playing an animation with multiple frames
		p.time += 1
		if p.time >= anims[p.state].fr then --the current frame has been on screen for long enough
			p.time = 0
			p.animindex = (p.animindex % #anims[p.state]) + 1 --go to the next frame
			--this loops animations. "punch" becomes (current index % 3) + 1, so 1,2,3,1,2,3,1...
			if p.animindex == 1 and anims[p.state].next then --at the moment the animation restarts,
				p.play = anims[p.state].next --play something else instead
				p.state = p.play
			end
		end
	end
	p.sp = anims[p.state][p.animindex] --lastly, update the current sprite number drawn to screen
end

function check_collision(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and
		x1 + w1 > x2 and
		y1 < y2 + h2 and
		y1 + h1 > y2
end

function gatesf(close)
	for i=1,#gates do
		if not gates[i].open and not close then
			tile=mget(gates[i].x,gates[i].y)
			mset(gates[i].x,gates[i].y,tile-1)
			gates[i].open=true
		end
		if gates[i].open and close then
			tile=mget(gates[i].x,gates[i].y)
			mset(gates[i].x,gates[i].y,tile+1)
			gates[i].open=false
		end
	end
end

function fire(o,d)
	local nbul={
		cw=false,
		cm=true,
		x=o.x,
		y=o.y,
		vx=0,
		vy=0,
		dir=d,
		sp=192,
		draw=drawb,
		update=updatebul,
		timer=100,
		a=0
	}
	add(buls,nbul)
end

function sword(s,nr,nc)
	local nsword={
		x=s.x+4,
		y=s.y+4,
		o=s,
		r=nr,
		c=nc,
		draw=draws,
		update=updates,
		timer=7
	}
	add(swrdl,nsword)
end

function parry(s,nr,nc1,nc2,nc3)
	local nparry={
		x=s.x+4,
		y=s.y+4,
		o=s,
		r=nr,
		c1=nc1,
		c2=nc2,
		c3=nc3,
		draw=drawpry,
		update=updatepry,
	}
	add(parryl,nparry)
end

function spawnen(ex,ey,t)
	if t=="turret" then
		local newtur={
			x=ex,
			y=ey,
			w=8,
			h=8,
			sp=122,
			ft=20,
			hp=2,
			mhp=2,
			draw=drawen,
			update=updaten
		}
	elseif t=="light" then
		local newlite={
			x=ex,
			y=ey,
			w=4,
			h=8,
			sp=193,
			f=false,
			spdx=0,
			spdy=0,
			cm=true,
			cw=false,
			dir="f",
			ft=15,
			hp=3,
			mhp=3,
			draw=drawen,
			update=updaten
		}
	end
end

function precomputeb(s,a,d,w,h)
	sw=(w or 1)*8
	sh=(h or 1)*8
	sx=(s%16)*8
	sy=flr(s/16)*8
	x0=(sw-1)/2
	y0=(sh-1)/2
	a=a/360
	sa=sin(a)
	ca=cos(a)
	for ix=0,sw+1 do
		for iy=0,sh+1 do
			sset((d%16)*8+ix,flr(d/16)*8+iy,0)
		end
	end
	for ix=0,sw+1 do
		for iy=0,sh+1 do
			local dx, dy=ix-x0,iy-y0
			local rx=flr(dx*ca-dy*sa+x0)
			local ry=flr(dx*sa+dy*ca+y0)
			
			if rx>=0 and rx<sw and ry>=0 and ry<sh then
			local col=sget(sx+rx,sy+ry)
			if col!=0 then
				local dx_d=(d%16)*8+ix
				local dy_d=flr(d/16)*8+iy
					if dx_d>=0 and dx_d<128 and dy_d>=0 and dy_d<128 then
						sset(dx_d,dy_d,col)
					end
				end
			end
		end
	end
end

function spawnen(ex,ey,et)
	local nen = {
		x=ex*8,
		y=ey*8,
		t=et,
		update=updaten,
		draw=drawo
	}
	if et==0 then
		nen.sp=208
		nen.w=8
		nen.h=8
		nen.hp=15
		nen.mhp=15
		nen.fp=flr(rnd(2))
		nen.ft=30
		nen.ftm=30
		nen.fn=0
	elseif et==1 then
		nen.sp=193
		nen.w=4
		nen.h=8
		nen.cm=true
		nen.cw=false
		nen.dir="f"
		nen.hp=10
		nen.mhp=10
		nen.ft=10
		nen.ftm=10
	end
	add(eneml,nen)
end
-->8
--update functions

function updates()
	dialog:update()
	dialog:queue("testing 123")
end

function updateg()
	dialog:update()
	updateplayer(player)
	for o in all(obl) do o:update() end
	for b in all(buls) do b:update() end
	for s in all(swrdl) do s:update() end
	for p in all(parryl) do p:update() end
	for e in all(eneml) do e:update() end
	if lev=="0" then
		if james.talked==true and april.talked==true and joseline.talked==true and not r0gates==true then
			gatesf(false)
			r0gates=true
			spawnen(32,29,0)
		end
	end
	if ptimer>20 then ptimer=20 end
	local i,j=1,1
	while buls[i] do
		if buls[i]:update() then
			if (i!=j) buls[j]=buls[i] buls[i]=nil
			j+=1
		else buls[i]=nil end
		i+=1
	end
	local k,l=1,1
	while swrdl[k] do
		if swrdl[k]:update() then
			if (k!=l) swrdl[l]=swrdl[k] swrdl[k]=nil
			l+=1
		else swrdl[k]=nil end
		k+=1
	end
	local y,z=1,1
	while parryl[y] do
		if parryl[y]:update() then
			if (y!=z) parryl[z]=parryl[y] parryl[y]=nil
			y+=1
		else parryl[y]=nil end
		z+=1
	end
	local a,b=1,1
	while eneml[a] do
		if eneml[a]:update() then
			if (a!=b) eneml[b]=eneml[b] eneml[b]=nil
			a+=1
		else eneml[a]=nil end
		b+=1
	end
end

function updatee()
	
end

function updateplayer(p)
	local xs = p.x
	local ys = p.y
	local px = p.x
	local py = p.y
	local cx = camx
	local cy = camy
	local ax = alertext.x
	local ay = alertext.y
	diag = true
	if not p.talking then
		--controls
		if btn(0) then
			p.spdx=-speed
			p.spdy=0
			p.dir="s"
			p.play="walks"
			p.f=false
			alertext.x+=p.spdx
			diag=false
			if btn(2) then
				p.spdy=-speed
				alertext.y+=p.spdy
				p.play="walkdb"
				p.dir="db"
				local mp = sqrt((p.spdx*p.spdx)+(p.spdy*p.spdy))
				p.spdx/=mp
				p.spdy/=mp
				p.spdx*=speed
				p.spdy*=speed
				--p.spdx*=0.7071
				--p.spdy*=0.7071
				diag=true
			elseif btn(3) then
				p.spdy=speed
				alertext.y-=p.spdy
				p.play="walkdf"
				p.dir="df"
				local mp = sqrt((p.spdx*p.spdx)+(p.spdy*p.spdy))
				p.spdx/=mp
				p.spdy/=mp
				p.spdx*=speed
				p.spdy*=speed
				--p.spdx*=0.7071
				--p.spdy*=0.7071
				diag=true
			end
		elseif btn(1) then
			p.spdx=speed
			p.spdy=0
			p.play="walks"
			p.f=true
			p.dir="sf"
			alertext.x+=p.spdx
			diag=false
			if btn(2) then
				p.spdy=-speed
				alertext.y+=p.spdy
				p.play="walkdb"
				p.dir="dbf"
				local mp = sqrt((p.spdx*p.spdx)+(p.spdy*p.spdy))
				p.spdx/=mp
				p.spdy/=mp
				p.spdx*=speed
				p.spdy*=speed
				--p.spdx*=0.7071
				--p.spdy*=0.7071
				diag=true
			elseif btn(3) then
				p.spdy=speed
				alertext.y-=p.spdy
				p.play="walkdf"
				p.dir="dff"
				local mp = sqrt((p.spdx*p.spdx)+(p.spdy*p.spdy))
				p.spdx/=mp
				p.spdy/=mp
				p.spdx*=speed
				p.spdy*=speed
				--p.spdx*=0.7071
				--p.spdy*=0.7071
				diag=true
			end
		elseif btn(2) then
			p.spdy=-speed
			p.spdx=0
			p.play="walkb"
			p.dir="b"
			alertext.y+=p.spdy
			diag=false
		elseif btn(3) then
			p.spdy=speed
			p.spdx=0
			p.play="walkf"
			p.dir="f"
			alertext.y+=p.spdy
			diag=false
		end
		
		--idle anims
		
		if not btn(0) and not btn(1) and not btn(2) and not btn(3) then
			p.spdx=0
			p.spdy=0
			if p.dir=="f" then
				p.play="idlef"
				p.f=false
			elseif p.dir=="b" then
				p.play="idleb"
				p.f=false
			elseif p.dir=="s" then
				p.play="idles"
				p.f=false
			elseif p.dir=="sf" then
				p.play="idles"
				p.f=true
			elseif p.dir=="df" then
				p.play="idledf"
				p.f=false
			elseif p.dir=="dff" then
				p.play="idledf"
				p.f=true
			elseif p.dir=="db" then
				p.play="idledb"
				p.f=false
			elseif p.dir=="dbf" then
				p.play="idledb"
				p.f=true
			end
		end
		
		--mp = sqrt((p.spdx*p.spdx)+(p.spdy*p.spdy))
		
		
		--fix jitter
		
		if diag then
			p.x=flr(p.x)+0.5
			p.y=flr(p.y)+0.5
			camx=flr(camx)+0.5
			camy=flr(camy)+0.5
			dialog.x=flr(dialog.x)+0.5
			dialog.y=flr(dialog.y)+0.5
		end
		
		--update player pos
		
		if not col0(p) or col6(p) then
			p.x+=p.spdx
			p.y+=p.spdy
			camx+=p.spdx
			camy+=p.spdy
		end
		
		--collision functions
		
		if col0(p) or col6(p) then
			p.x=xs
			p.y=ys
			camx=cx
			camy=cy
			alertext.x=ax
			alertext.y=ay
			p.spdx=0
			p.spdy=0
		end
		
		if col4(p) then
			gatesf(true)
			if lev=="0" and c0==false then
				c0=true
			end
			if lev=="01" and c0==true then
				lev="1"
			end
		end
		
		if col5(p) then
			gatesf(false)
			if lev=="0" and c0==true then
				lev="01"
			end
		end
		
		if lev=="0" then
				
			--open doors
				
			if col1(p) then
				local x = 32+camx
				local y = 30+camy
				alerttext("pRESS ❎ TO OPEN",x,y,5,6,7,0)
				if btnp(5) then
					opendoor()
				end
				ax=x
				ay=y
			else
				alerttext("",0,0,0)
			end
		elseif lev=="1" then
			--combat level 1
			speed=2
			showui=true
			if p.weapon=="gun" then
				if btn(4) and ftimer<=0 then
					fire(p,p.dir)
					ftimer=7
				end
			elseif p.weapon=="sword" then
				if btn(4) and stimer<=0 then
					sword(p,10,7)
					stimer=8
				end
			end
			if btn(5) and ptimer>=20 then
				parry(player,15,12,13,1)
				if player.weapon=="gun" then
					player.weapon="sword"
				elseif player.weapon=="sword" then
					player.weapon="gun"
				end
				ptimer=0
			end
			ftimer-=1
			stimer-=1
			ptimer+=1
		end
	else
		p.spdx=0
		p.spdy=0
		if p.dir=="f" then
			p.play="idlef"
			p.f=false
		elseif p.dir=="b" then
			p.play="idleb"
			p.f=false
		elseif p.dir=="s" then
			p.play="idles"
			p.f=false
		elseif p.dir=="sf" then
			p.play="idles"
			p.f=true
		elseif p.dir=="df" then
			p.play="idledf"
			p.f=false
		elseif p.dir=="dff" then
			p.play="idledf"
			p.f=true
		elseif p.dir=="db" then
			p.play="idledb"
			p.f=false
		elseif p.dir=="dbf" then
			p.play="idledb"
			p.f=true
		end
	end
	if showui then
		tm=ptimer/20
		ch=player.hp/player.mhp
		if ch>0.6 and ch<=(player.mhp/10) then
			hc=hi
		elseif ch>0.3 and ch<=0.6 then
			hc=med
		elseif ch>=0 and ch<=0.3 then
			hc=lo
		else
			hc=7
		end
		if player.hp<=0 then
			room="end"
		end
	end
	animate(p)
end 

--npc code

function updatenpc(n)
	if check_collision(player.x,player.y,player.w,player.h,n.x,n.y,n.w,n.h) then
		if btn(5) and not player.talking then
			if not n.talked then
				n.talked=true
				for i, l in pairs(n.lines) do
					dialog:queue(l,false,n.name)
				end
			elseif n.talked then
				for i, al in pairs(n.linesa) do
					dialog:queue(al,false,n.name)
				end
			end
		elseif not btn(5) and not player.talking then
			alerttext("pRESS ❎ TO INTERACT",24+camx,30+camy,5,6,7,0)
		end
	end
end

function updatebul(b)
	if b.dir=="f" then
		b.vx=0
		b.vy=bulspd
		b.a=270
		b.sp=bul_rot[270]
	elseif b.dir=="b" then
		b.vx=0
		b.vy=-bulspd
		b.a=90
		b.sp=bul_rot[90]
	elseif b.dir=="s" then
		b.vx=-bulspd
		b.vy=0
		b.a=0
		b.sp=bul_rot[0]
	elseif b.dir=="sf" then
		b.vx=bulspd
		b.vy=0
		b.a=180
		b.sp=bul_rot[180]
	elseif b.dir=="df" then
		b.vx=-bulspd
		b.vy=bulspd
		b.a=315
		b.sp=bul_rot[315]
		local mp=sqrt((b.vx*b.vx)+(b.vy*b.vy))
		b.vx/=mp
		b.vy/=mp
		b.vx*=bulspd
		b.vy*=bulspd
	elseif b.dir=="dff" then
		b.vx=bulspd
		b.vy=bulspd
		b.a=225
		b.sp=bul_rot[225]
		local mp = sqrt((b.vx*b.vx)+(b.vy*b.vy))
		b.vx/=mp
		b.vy/=mp
		b.vx*=bulspd
		b.vy*=bulspd
	elseif b.dir=="db" then
		b.vx=-bulspd
		b.vy=-bulspd
		b.a=45
		b.sp=bul_rot[45]
		local mp = sqrt((b.vx*b.vx)+(b.vy*b.vy))
		b.vx/=mp
		b.vy/=mp
		b.vx*=bulspd
		b.vy*=bulspd
	elseif b.dir=="dbf" then
		b.vx=bulspd
		b.vy=-bulspd
		b.a=135
		b.sp=bul_rot[135]
		local mp = sqrt((b.vx*b.vx)+(b.vy*b.vy))
		b.vx/=mp
		b.vy/=mp
		b.vx*=bulspd
		b.vy*=bulspd
	end
	b.x+=b.vx
	b.y+=b.vy
	b.timer-=1
	if col0(b) then
		return false
	end
	return b.timer>0
end

function updates(s)
	s.x=s.o.x+4
	s.y=s.o.y+4
	s.timer-=1
	return s.timer>0
end

function updatepry(p)
	p.x=p.o.x+4
	p.y=p.o.y+4
	p.r-=1
	return ptimer>0
end

function updaten(e)
	local pat=nil
	if e.t==0 then
		if e.fp==0 then
			pat=firepats.h
		elseif e.fp==1 then
			pat=firepats.d
		end
		if e.ft>=30 and e.ft<60 then
			e.sp=224
		elseif e.ft>=60 and e.ft<90 then
			e.sp=240
		elseif e.ft>=90 and e.ft<120 then
			e.sp=198
		elseif e.ft>=120 then
			for p in all(pat) do
				fire(e,p)
				e.ft=0
				e.sp=208
			end
		end
		e.ft+=1
	end
	return e.hp>0
end
-->8
--draw functions

function draws()
	cls(1)
	dialog:draw()
end

function drawg()
	dialog.x+=player.spdx
	dialog.y+=player.spdy
	rects=false
	twd=print(alertext.text,0,-50)
	cls(1)
	if lev=="0" then
		map(0,0,0,0,31,32)
	elseif lev=="01" then
		map(0,0,0,0,70,32)
	elseif lev=="1" then
		map(0,0,0,0,71,32)
		rectfill(0,0,30*8-1,32*8,1)
		showui=true
		del(obl,james)
		del(obl,april)
		del(obl,joseline)
	end
	--for i, val in pairs(dialog.dialog_queue) do
		--print(tostr(val))
		--print(count(dialog.dialog_queue))
	--end
	for o in all(obl) do o:draw() end
	for o in all(buls) do o:draw() end
	for e in all(eneml) do e:draw() end
	camera(camx,camy)
	for o in all(swrdl) do o:draw() end
	for o in all(parryl) do o:draw() end
	player:drawp()
	--rectfill((player.x/8)+camx,((player.y-2)/8)+camy,((player.x+7)/8)+camx,((player.y+8)/8)+camy,7)
	dialog:draw()
	if alertext.text=="" then
		rects=false
	else
		rects=true
	end
	if rects==true then
		rectfill(alertext.x-10,alertext.y-5,alertext.x+twd+10,alertext.y+10,alertext.col3)
		rect(alertext.x-10,alertext.y-5,alertext.x+twd+10,alertext.y+10,alertext.col4)
	end
	--[[ debugging
	print(rects,7,10,1)
	print(twd,7,20,1)]]--
	print(eneml[1].fp,7+camx,40+camy,0)
	--print(#eneml,7+camx,40+camy,0)
	print(alertext.text,alertext.x+1,alertext.y+1,alertext.col2)
	print(alertext.text,alertext.x,alertext.y,alertext.col)
	if showui then
		rectfill(1+camx,2+camy,tm*57+camx+1,13+camy,0)
		rectfill(2+camx,3+camy,60+camx,12+camy,7)
		print("weapon: "..player.weapon,camx+7,camy+6,6)
		print("weapon: "..player.weapon,camx+6,camy+5,5)
		rectfill(66+camx,3+camy,125+camx,12+camy,5)
		rectfill(66+camx,3+camy,ch*60+camx+65,12+camy,hc)
		rect(65+camx,2+camy,126+camx,13+camy,0)
	end
end

function drawe()
	cls(8)
end

function drawo(o)
	spr(o.sp,o.x,o.y,1,1,o.f)
end

function drawb(b)
	spr(b.sp,b.x,b.y,1,1)
end

function draws(s)
	circfill(s.x,s.y,s.r,s.c)
end

function drawpry(p)
	circfill(p.x,p.y,p.r,p.c1)
	circfill(p.x,p.y,p.r/1.5,p.c2)
	circfill(p.x,p.y,p.r/2,p.c3)
end
-->8
--dialog code

dialog = {
	x = 8,
	y = 97,
	color = 5,
	max_chars_per_line = 27,
	max_lines = 4,
	dialog_queue = {},
	blinking_counter = 0,
	showbox=false,
	name='',
	namel=0,
	init = function(self)
	end,
	queue = function(self, message, autoplay, name)
		-- default autoplay to false
		self.showbox=true
		player.talking=true
		self.name=name
		self.namel=print(self.name,0,-50)
		autoplay = type(autoplay) == "nil" and false or autoplay
		add(self.dialog_queue, {
		message = message,
		autoplay = autoplay
	})
		
		if (#self.dialog_queue == 1) then
			self:trigger(self.dialog_queue[1].message, self.dialog_queue[1].autoplay)
		end
	end,
	trigger = function(self, message, autoplay)
		self.autoplay = autoplay
		self.current_message = ''
		self.messages_by_line = nil
		self.animation_loop = nil
		self.current_line_in_table = 1
		self.current_line_count = 1
		self.pause_dialog = false
		self:format_message(message)
		self.animation_loop = cocreate(self.animate_text)
	end,
	format_message = function(self, message)
		local total_msg = {}
		local word = ''
		local letter = ''
		local current_line_msg = ''
		
		for i = 1, #message do
			-- get the current letter add
			letter = sub(message, i, i)
			
			-- keep track of the current word
			word ..= letter
			
			-- if it's a space or the end of the message,
			-- determine whether we need to continue the current message
			-- or start it on a new line
			if letter == ' ' or i == #message then
				-- get the potential line length if this word were to be added
				local line_length = #current_line_msg + #word
				-- if this would overflow the dialog width
				if line_length > self.max_chars_per_line then
					-- add our current line to the total message table
					add(total_msg, current_line_msg)
					-- and start a new line with this word
					current_line_msg = word
				else
					-- otherwise, continue adding to the current line
					current_line_msg ..= word
				end
				
				-- if this is the last letter and it didn't overflow
				-- the dialog width, then go ahead and add it
				if i == #message then
					add(total_msg, current_line_msg)
				end
				
				-- reset the word since we've written
				-- a full word to the current message
				word = ''
			end
		end
		
		self.messages_by_line = total_msg
	end,
	animate_text = function(self)
		-- for each line, write it out letter by letter
		-- if we each the max lines, pause the coroutine
		-- wait for input in update before proceeding
		for k, line in pairs(self.messages_by_line) do
			self.current_line_in_table = k
			for i = 1, #line do
				self.current_message ..= sub(line, i, i)
				
				-- press btn 5 to skip to the end of the current passage
				-- otherwise, print 1 character per frame
				-- with sfx about every 5 frames
				if (not btnp(5)) then
					if (i % 5 == 0) sfx(0)
						yield()
				end
			end
			self.current_message ..= '\n'
			self.current_line_count += 1
			if ((self.current_line_count > self.max_lines) or (self.current_line_in_table == #self.messages_by_line and not self.autoplay)) then
				self.pause_dialog = true
				yield()
			end
		end
			
		if (self.autoplay) then
			self.delay(30)
		end
	end,
	shift = function (t)
		local n=#t
		for i = 1, n do
			if i < n then
				t[i] = t[i + 1]
		else
			t[i] = nil
		end
	end
	end,
	-- helper function to add delay in coroutines
	delay = function(frames)
		for i = 1, frames do
			yield()
		end
	end,
	update = function(self)
		if (self.animation_loop and costatus(self.animation_loop) != 'dead') then
			if (not self.pause_dialog) then
				coresume(self.animation_loop, self)
			else
				if count(self.dialog_queue) == 1 and btnp(4) and self.current_line_in_table == #self.messages_by_line then
					self.showbox=false
					player.talking=false
				end
				if btnp(4) then
					self.pause_dialog = false
					self.current_line_count = 1
					self.current_message = ''
				end
			end
		elseif (self.animation_loop and self.current_message) then
			if (self.autoplay) self.current_message = ''
			self.animation_loop = nil
		end
			
		if (not self.animation_loop and #self.dialog_queue > 0) then
			self.shift(self.dialog_queue, 1)
			if (#self.dialog_queue > 0) then
				self:trigger(self.dialog_queue[1].message, self.dialog_queue[1].autoplay)
				coresume(self.animation_loop, self)
			end
		end
			
		if (not self.autoplay) then
			self.blinking_counter += 1
			if self.blinking_counter > 30 then self.blinking_counter = 0 end
			end
		end,
	draw = function(self)
		
		-- display message and box
			if self.showbox==true then
				--name print
				rectfill(self.x-9,self.y-13,self.x+self.namel-4,self.y,7)
				rect(self.x-8,self.y-13,self.x+self.namel-4,self.y+2,0)
				print(self.name, self.x-4, self.y-10,6)
				print(self.name, self.x-5, self.y-11,self.color)
				--dialog box print
				rectfill(self.x-8,self.y-5,self.x+119,self.y+30,7)
				rect(self.x-8,self.y-5,self.x+119,self.y+30,0)
			end
			if (self.current_message) then
				print(self.current_message, self.x+1, self.y+1, 6)
				print(self.current_message, self.x, self.y, self.color)
			end
			
		-- draw blinking cursor at the bottom right
		if (not self.autoplay and self.pause_dialog) then
			if self.blinking_counter > 15 then
				if (self.current_line_in_table == #self.messages_by_line) then
					-- draw square
					
					rectfill(
						self.x + 111,
						self.y + 21,
						self.x + 111 + 3,
						self.y + 21 + 3,
						6
					)
					--outer square
					rectfill(
						self.x + 110,
						self.y + 20,
						self.x + 110 + 3,
						self.y + 20 + 3,
						self.color
					)
				else
					-- draw arrow
					
					--inner arrow
					line(self.x + 111, self.y + 22, self.x + 115, self.y + 22, 6)
					line(self.x + 111, self.y + 22, self.x + 113, self.y + 24, 6)
					line(self.x + 115, self.y + 22, self.x + 113, self.y + 24, 6)
					pset(self.x + 113, self.y + 23, 6)
					--outer arrow
					line(self.x + 110, self.y + 21, self.x + 114, self.y + 21, self.color)
					line(self.x + 110, self.y + 21, self.x + 112, self.y + 23)
					line(self.x + 114, self.y + 21, self.x + 112, self.y + 23)
					pset(self.x + 112, self.y + 22)
				end
			end
		end
	end
}
-->8
--thanks
--[[
	thanks to:
		SHY for their guide "tHE SECRET GUIDE TO BULLETS, SPRITES, AND ANIMATIONS",
		

]]--
__gfx__
00888800333333333333333333333333333333333333333300006666666666666666000055555555555555555555555555555555555555555555555555555555
0822228033333333333333333333333333333333333b333300006555555555555556000055555555555555555555555555555555555555555444444444444445
888000283333333333333333333333333333333333b33333000065566666666665560000544444455422222555ffffffffffffffffffff5554ffffffffffff45
82288008333333333333333333333333333333333333333b0000655655555555655600005647c4455622222555ffffffffffffffffffff5554f4444444444f45
8002288833333336636663363333333333333333333333b3000065566656566565560000544cc4455422222555ff4444444444444444ff5554f4ffffffff4f45
280002823333336666666666633333333333333333b33333000065565555555565560000544444a554a2222555ff4ffffffffffffff4ff5554f4ffffffff4f45
02888820333333655655565556333333333333333b333333000065565665656665560000564444455622222555ff4f444444444444f4ff5554f4ff5555ff4f45
002222003333366666666666666333333333333333333333000065565555555565560000555555555555555555ff4f455555555554f4ff5554f4ff5555ff4f45
2e22222e3333336555655565556333333333e33333333333000065563366633365560000555555555555555555ff4f4554ffff4554f4ff5554f4ff5555ff4f45
e2e22222333336666666666666633333333eae3333b333b3000065563667763365560000564444455622222555ff4f4554ffff4454f4ff5554f4ff5555ff4f45
2222e2e2333336556555655556333333393beb333b3b3b3b000065565666676365560000544444a554a2222555ff4f4554ffffff54f4ff5554f4ffffffff4f45
22222e2e3333336666666666666333339a93b3333b333b33000065565666667665560000544cc4455422222555ff4f4554ffffff54f4ff5554f4ffffffff4f45
22222222333336655565556555633333b9b33833333b33330000655655666676655600005647c4455622222555ff4f4554ffffff54f4ff5554f4444444444f45
22e2e2223333366666666666663333333b338a8333b3b333000065565556666665560000544444455422222555ff4f4554ffffff54f4ff5554ffffffffffff45
2e2e22223333365556555655563333333333b8b33333b333000065563555666365560000555555555555555555ff4f4554ffff4454f4ff555444444444444445
2222222233333666666666666663333333333b3333333333000065563355553365560000555555555555555555ff4f4554ffff4554f4ff555555555555555555
222222223333365565556555663333333333336555633333000065566666666665560000555555555555555555ff4f455555555554f4ff555555555554ffff45
22222222333333666666666663333333333336666663333300006555555555555556000055444a455522222555ff4f444444444444f4ff555555555544ffff44
222222223333333636663336333333333333365565633333000066666666666666660000554444455522222555ff4ffffffffffffff4ff55ffffffffffffffff
2222222233333333333333333333333333336666666633330000777777777777777700005547c4455522222555ff4444444444444444ff55ffffffff44444444
222222223333333333333333333333336333656555656633000067667676676766760000554cc4455522222555ffffffffffffffffffff5544444444ffffffff
222222223333333333333333333333336666666666666666000077777777777777770000554444455522a22555ffffffffffffffffffff55ffffffffffffffff
222222223333333333333333333333335655565556555655000066767667676676760000554644655546446555555555555555555555555544ffff4455555555
222222223333333333333333333333336666666666666666000077777777777777770000555555555555555555555555555555555555555554ffff4555555555
54ffff4554ffff4555555555336663336555655555655565555555555555555554ffff45555555555555555554ffff455555555554ffff4554f4ff5555ff4f45
44ffff4554ffff4454444444335666336666666666666666444444454444444444ffff4454a444555222225554ffff454444444444ffff4544f4ff5555ff4f44
ffffff4554ffffff54ffffff333555336336655565556556ffffff45ffffffffffffffff544444555222225554ffff45ffffffffffffff45fff4ff5555ff4fff
ffffff4554ffffff54ffffff333333333333666666666663ffffff45ffffffffffffffff544c74555222225554ffff45ffffffffffffff45fff4ff5555ff4fff
ffffff4554ffffff54ffffff366636663333366555663333ffffff45ffffffffffffffff544cc4555222225554ffff45ffffffffffffff45fff4ff5555ff4fff
ffffff4554ffffff54ffffff356536653333366666633333ffffff45ffffffffffffffff54444455522a225554ffff45ffffffffffffff45fff4ff5555ff4fff
444444455444444454ffff4433533553333333655663333344ffff4544ffff4444444444564464555644645554ffff454444444444ffff4544f4ff5555ff4f44
555555555555555554ffff4533333333333336666633333354ffff4554ffff4555555555555555555555555554ffff455555555554ffff4554f4ff5555ff4f45
00777700007777000077770000777700000000000077770000000000007777006666000011111111111111111111111111111111116661115555555555555555
00cffc0000ffff0000f7770000fff7000077770000ffc7000077770000ffc7006556000011111111111111111111111111111111166776114c77ccc455555555
00ffff0000ffff0000ff770000fff70000ffc70000fff70000ffc70000fff70065560000111111aaaaaaa77aaa1111111111111116666761f77ccccffccc77cf
0071170000711700000177000001170000fff7000001170000fff7000001170065560000111111aa99999999aa111111111111111566666147cccc74fcccc77f
0011110000111100000117000001170000011700000117000001170000011700655600001111117a65656515a711111111111111c5566661fcccc77f47cccc74
001551000015510000015700000510000001170000051000000117000005100065560000111111776565656577111111111111111c55566cfccc77cff77ccccf
000550000005500000055000000550000015510000055000000150000005500065560000111111a7555555557a1111111111111111cc55c1555555554c77ccc4
000550000005500000055000000550000000500000055000000050000005500065560000111116aa65656565aa611111111111111111cc115555555555555555
000000000077770000000000007777000000000000777700000000000077770000006666111111aa00000000aa111111aa6333331111111155ff4f4554f4ff55
0077770000c777000077770000c777000077770000cffc000077770000cffc0000006556111116aa00000000aa611111a763333311cccc1155cc77c55c77cc55
00c7770000ff770000c7770000ff770000cffc0000ffff0000cffc0000ffff00000065561111167a00000000a7611111773333331111111155ccc775577ccc55
00ff77000001770000ff77000001770000ffff000071170000ffff000071170000006556111111770000000077111111996333331cccc11155cccc7557cccc55
000177000001170000017700000117000071170000111100007117000011110000006556111116a7000000007a6111115563333311111111557cccc55cccc755
000117000001570000011700000157000011110000155100001111000015510000006556111116aa00000000aa61111165333333111111115577ccc55ccc7755
001557000005500000151700000550000015500000055000000551000005500000006556111116aa00000000aa61111155333333111cccc155c77cc55cc77c55
000500000005500000005000000550000000500000055000000500000005500000006556111116aa00000000aa611111656333331111111155ff4f4554f4ff55
0000000000777700000000000077770056222225567676750088880000dddd0000006556111116aaa77aaaaaaa611111333336aa33333111111116aaaa611111
0077770000777700007777000077770055222225555676750088cb0000955900000065561111169999999999996111113333367a33311111111116aaa7611111
0077770000777700007777000077770056222225567676750088cc0000555500000066661111166565656565656111113333337733111111aa777aaaa77aaaaa
00777700007777000077770000777700562222255676767500866000000550000000777711111165656565656511111133333699331111119999999999999999
0077770000777700007777000077770055a2222555567aa5006cc600008888000000676711111165555555555511111133333665311111115156565555656515
00777700001771000077770000177100562222255676767500666600008888000000777711111116656565656111111133333365311111115656565665656565
00077100000550000017700000055000562222255676767500055000000dd0000000667611111116666111161111111133333355111111115555555555555555
00050000000550000000500000055000552222255556767500055000000dd0000000777711111111111111111111111133333665111111115656565665656565
0000000000777700000000000077770000555500666666666666666600dddd0065560000ffffffff00000000111111111111111111133333aaaaaaaaaaaaaaaa
0077770000777700007777000077770000bffb00555555565555555600c1dd0065560000f444444f000000001111111111111111111113339999997aaa999999
0077770000f777000077770000f7770000ffff00666666666666666600111d0066660000f444444f0000000011111113311111111111113365656577aa656565
00f777000001770000f7770000017700005aa500555555557777777700deed0077770000ffffffff00000000111111133111111111111133656565a7aa656565
0001770000117700000177000011770000aaaa00665656656676766700eeee0076760000ffffffff00000000111111333311111111111113555555aaa7555555
0011770000155700001177000015570000aaaa00555555557777777700e55e00777700002556655200000000111111333311111111111113656565aa77656565
00055700000550000001570000055000005dd500566565667667676600055000676600002555555200000000111113333331111111111111661166aa7a666661
00005000000550000005000000055000000ff000555555557777777700055000777700002255552200000000111333333333311111111111111116aaaa611111
33333333222222226555555633333333222222225555555555555555000000000000000000000000000000000000000000000000000000000000000000000000
33333333222222226555555533333333222222224c22722455555555000000000000000000000000000000000000000000000000000000000000000000000000
3333333322222222666666663333333322222222f222227ff22c2ccf000000000000000000000000000000000000000000000000000000000000000000000000
33c3333322c2222277777777335333332252222242222224f72222cf000000000000000000000000000000000000000000000000000000000000000000000000
3333333322222222766767663333333322222222f72222cf42222224000000000000000000000000000000000000000000000000000000000000000000000000
3333333322222222777777773333333322222222f22c2ccff222227f000000000000000000000000000000000000000000000000000000000000000000000000
3333333322222222667676673333333322222222555555554c227224000000000000000000000000000000000000000000000000000000000000000000000000
33333333222222227777777733333333222222225555555555555555000000000000000000000000000000000000000000000000000000000000000000000000
666666666666666666666666666666660000000055ff4f4554f4ff55000000000000000000000000000000000000000000000000000000000000000000000000
5555555555555555555555566555555500000000552722c55272cc55000000000000000000000000000000000000000000000000000000000000000000000000
65566666666665566555555665555556000000005522222552222c55000000000000000000000000000000000000000000000000000000000000000000000000
655655555555655665555556655555560000000055c2222557222255000000000000000000000000000000000000000000000000000000000000000000000000
65566565656665566555555665555556000000005522227552222c55000000000000000000000000000000000000000000000000000000000000000000000000
655655555555655665555556655555560000000055c2222552222255000000000000000000000000000000000000000000000000000000000000000000000000
655666565665655665555556655555560000000055cc27255c227255000000000000000000000000000000000000000000000000000000000000000000000000
655655555555655665555556655555560000000055ff4f4554f4ff55000000000000000000000000000000000000000000000000000000000000000000000000
65566666666665566555555666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555555555555665555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666666666666666666665555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777777777777777777765555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76676766767667676676766765555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777777777777777777765555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
67667676676766767667676665555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777777777777777777765555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65555556666666666555555665555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65555556555555555555555565555556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65555556655555566666666666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65555556655555567777777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65555556655555566676766776766767000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65555556655555567777777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65555556655555567676676767667676000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65555556655555567777777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000670000000000000067700000000000066700077077077000000000000000000000000000000000000000000000000000000000000000000000000
08888800008668000006700000668700000677000086670077555577000000000000000000000000000000000000000000000000000000000000000000000000
8eeee880006667000086680000666700006687000066670005888850000000000000000000000000000000000000000000000000000000000000000000000000
777eee880001100000666700000110000066670000011000758ee857000000000000000000000000000000000000000000000000000000000000000000000000
777eee88006556000001100000056000000110000016500075888857000000000000000000000000000000000000000000000000000000000000000000000000
8eeee880001551000065560000051000000560000005500005555550000000000000000000000000000000000000000000000000000000000000000000000000
08888800000000000015510000000000000510000000000077677677000000000000000000000000000000000000000000000000000000000000000000000000
00000000000cc000000cc000000cc000000cc000000cc00077677677000000000000000000000000000000000000000000000000000000000000000000000000
77077077006670000000000000867800008670000006700000000000000000000000000000000000000000000000000000000000000000000000000000000000
77555577008667000066700008e88e8008e867000066670000000000000000000000000000000000000000000000000000000000000000000000000000000000
05eeee50006667000086670000866800008667000066670000000000000000000000000000000000000000000000000000000000000000000000000000000000
75eeee57000110000066670000011000000110000001100000000000000000000000000000000000000000000000000000000000000000000000000000000000
75eeee57000650000001100000655600000650000165561000000000000000000000000000000000000000000000000000000000000000000000000000000000
05555550000150000006500000155100000150000005500000000000000000000000000000000000000000000000000000000000000000000000000000000000
77677677000000000001500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77677677000cc000000cc000000cc000000cc000000cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000
77077077000670000000000000867800006670000066700000000000000000000000000000000000000000000000000000000000000000000000000000000000
77555577006667000006700008666780086667000066670000000000000000000000000000000000000000000000000000000000000000000000000000000000
05eeee50006667000066670000666700006667000066670000000000000000000000000000000000000000000000000000000000000000000000000000000000
75e88e57000110000066670000011000000110000001100000000000000000000000000000000000000000000000000000000000000000000000000000000000
75eeee57006556000001100000655600006556000165561000000000000000000000000000000000000000000000000000000000000000000000000000000000
05555550001551000065560000155100001551000005500000000000000000000000000000000000000000000000000000000000000000000000000000000000
77677677000000000015510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77677677000cc000000cc000000cc000000cc000000cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000
77077077006670000000000000868700000670000006770000000000000000000000000000000000000000000000000000000000000000000000000000000000
7755557700666700006670000068e800008668000066870000000000000000000000000000000000000000000000000000000000000000000000000000000000
05888850006667000066670000668700006667000066670000000000000000000000000000000000000000000000000000000000000000000000000000000000
75888857000110000066670000011000000110000001100000000000000000000000000000000000000000000000000000000000000000000000000000000000
75888857006556000001100000056000016556100005610000000000000000000000000000000000000000000000000000000000000000000000000000000000
05555550001551000065560000051000000550000005500000000000000000000000000000000000000000000000000000000000000000000000000000000000
77677677000000000015510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77677677000cc000000cc000000cc000000cc000000cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000101010300010101010100000000000001010103000101010101000000000000010101030001010101010101010000000101010300010101010100000000000000000140404040010101000000000000000001400040404001010000000000050000014040404040404000000000000101000140004040404040
1010012020000000000000000000000001010101000000000000000000000000010101010000000000000000000000000101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
060707070707070707070707070707070707070707070707070707070707b107070707070707070707070707070707070707070707070707070707070707070707070707070708000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
160404040404040404040404040404040404040404040b0c0c0c0c0c0c0db00401240b0c0c0c0c0c0c0c0c0c0c0c0c0c0c0d040404040404040404040404040404040404040418000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
160404040404040415040415041404040404040404041b1020202020201db00411129520202020202020202a20201020201d050404040404040102020202020202020203150418000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
160404040504040404040404040404041404040404045e2020102020101db0041112292020201020202020323c3c3c0a3c3e040404040401022412121212121212121225020318000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
160404040404040404140404040404040404040404041b1020207920201db00411125e20102020202010203b20102020201d0415040401241212120b0c4f0a860c0d1212122518000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
160404040404140404040404150404040404040404042b2c0f201020201db00411121b20202020202020203b20202020205f040404141112120b0c1f10202020201e0c0d121218000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1604041404040404170404010202020202030102020202021b202020201db00411123f3c3c3c3c3c3c3c3c3d1020202020960404040124120b1f2020202020202020101e0d1218000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
160b0c0c2e4f4f4f4f0c0d2412121212122524121212121229202020101db00411125e20202020202020103b20202020205f0404041112122a20102020202079202020205f1218000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
161b20203b20202020201d121212121212121212352222222b2c4e4e2c2db00411122a20101020202020202a20202010105f0404012412129520202020792020202010203a1218000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
161b20103b20202020201d12352222222234121225030404040404040404b00411125e20201020202020203b20202020201d0404111212122b0f2020201020201020200e2d1218000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
161b20203b20201020201e090c0d04040421341212250304040404040404b30421342b2c2c2c4e8585852c2f0f102020201d040124121212122b2c0f20202020200e2c2d121218000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
161b20203b20202020202010101d17040404213412122503040414046d4c4c7d0421222222222222222222343f3c0a0a3c3e0124121212121212122b2c851a4e2c2d1212123518000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
163f3c093010202020202020105f040405040411121212136d4c4c4c4c5d4c4c4c4d4c4c4c7d0404040404111b201020101d241212121235341212121212121212121212352318000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
161b10202020202020102020201d0404040404213412126f4b4c4c5d4c4c4c4c4c4c4c5d4c4c7d04040404112b4e1a1a852d121212121213212222222222222222222222230418000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
162b2c2c2c4e4e4e04042c2c2c2d04046d4c4c4c591212125b4c4c4c4c4c4c5d4c4c4c4c4c4c4c4c4c4c7d21223412121212121212352223040404040404040404040404040418000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
16040404040404170404040404046d4c4c4c4c4c591212125b4c7b040404a304047c4c4c4c4c4c4c4d4c4c4c7d213412121235222223046d4c4d4c4c4c4c4c4c7d040404040418000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6804040404050404040405046d4c5d4c4c4c4c4d591212125c0404140404b00404040404047c4c4c4c4c4c4c4c7d11121212136d4c4c4c4c4c4c4c5d4c4c4d4c5d4c7d04040478000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4c4c7d0404046d4c04044c4c4c4c4c4c4c4c7b046c121212130404040404b0150504040404047c4c4c4c5d4c4c4c591212125b4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4c4c4c4c4c5d5d4c04044c4c5d4c4c7b0404150411121212130417040404b0040404040404040404047c4c4c4d4c591212125b5d4c4d4c5d4c4c7b7c4c4c4c4c4c5d4c4c4c4d5d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4c4c4c4c4c4c4c4c04044c4c4c4c7b040404040411121212130404040404b004040404010202020202037c4c4c4c591212125b4c4c4c4c7b040404040404047c4c4c4c4c5d4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4c5d4c4c4c4c4c4c04041404040404040417040b4f0c090c4f0d04040404b0040414012412121212122502037c4c591212125b4c7b0404140404041505040404047c4c4c4c4c4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4c4c4c4c4d7b04040404040404040404040b0c1f20202020201e0c0d0404b00404040b0c0c4f0a860c0c0d2502036c1212125c0404040404040404040401020202020304040448000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4c4c4c7b0404050b04044f4f0c0d04040b1f2020102020202020201e0d04b00404045e202010202020201d12122524121212130404040404040404040124121212121304040418000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
580404041504041b20042020201d050b1f20202020202010102020201e0db004040495102020202020205f12121212121212130504040404041504012412121212122503040418000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
160417040404041b20042010201d041b101020102020202020792020101db0040404952020202010202039121212121212121304040404040404050b0c2e0c0c090c0c0d140418000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
160404040b090c1f20042020101d043f3c3c3c3c3c3c362020201020101db00404045e202020202020209612352234121212130404040b4f864f0c1f203b20102020101d040418000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
160404045e20202010042020201d042b0f20202020203b20202020200e2db00404052b2c2c851a4e2c2c2d12130411121212250304041b2020202020203b202020202096040418000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
161404045e10323c3c043c3c361d04042b0f2020102029202010200e2d04b004040421341212121212121212130421341212120b0c0c1f2010207920103b20202020205f040418000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
160404042b2c2f0f10200e2c2f2d0404042b2c2c2c2c2f2c2c2c2c2d0404b0808080042122222222222222222304041112121295202020202020202020313c3c0a3c3c3e040418000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
262727272727272765652727272727272727272727272727272727272727a204048004040404040404040404040414213412122a2020102020201020202020202020201d040418000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000058202020812010102020202010101020202020841010206504048004040404040404040404040404042134122b2c2c2c2c2c2c2c2c2c2c2c2c2c2c2c2d040418000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000026272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272727272728000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
