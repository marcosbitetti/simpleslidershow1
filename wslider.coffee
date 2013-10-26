#################
#
# Gerenciador de Slides
#
#################
class CardWidget

	constructor: (name,@IMAGES,IMAGES_PATH) ->
		@canvas = document.getElementById name + '_canvas'
		@canvas.width = @canvas.parentNode.parentNode.offsetWidth
		@canvas.height = @canvas.parentNode.parentNode.offsetHeight

		@imagens = []
		@links = []
		@loaded = 0
		@fps = 1000/30
		@delayTime = 7
		@curImage = null
		@curAlpha = 1
		@curDelay = 0
		@transition = 0
		@alternateTransitions = false
		try
			if slides_trans != undefined
				if slides_trans == "alternate"
					@transition = 0
					@alternateTransitions = true
				else
					@transition = slides_trans
					if @transition>5
						@transition = 0
		catch err
		try
			if slides_time != undefined
				@delayTime = parseInt(slides_time) or 7
		catch err
		for url in IMAGES
			do (url) =>
				link = null
				if typeof(url)=='object'
					try
						link = url[1]
						url = url[0]
					catch err
						link = url.link
						url = url.image
				img = new Image()
				img.onload = @imageLoaded
				img.onerror = (e) ->
					#alert e
				img.src = IMAGES_PATH + url
				
				@imagens.push img
				@links.push link

		ret = document.getElementById "wslider_seta_r_"+name
		ava = document.getElementById "wslider_seta_a_"+name

		@addEvent ret, 'click', (e) =>
				@curImage -= 1
				if @curImage<0
					@curImage = @imagens.length-1
				@swap @curImage
		@addEvent ava, 'click', (e) =>
				@curImage += 1
				if @curImage>=@imagens.length
					@curImage = 0
				@swap @curImage
		@addEvent @canvas, 'click', (e) =>
			link = @links[@curImage]
			if link != null
				window.document.location.href = link

	imageLoaded: (e) =>
		@loaded += 1
		if @loaded >= @IMAGES.length
			@curImage = @IMAGES.length
			@swap()
			@timmer()
		@render e.target

	timmer: () =>
		if @dirty
			@update()
		else
			@delay()
		window.setTimeout @timmer, @fps

	swap: (v) =>
		if v==undefined
			@curImage += 1
		@curImage = 0 if @curImage>=@IMAGES.length
		@curAlpha = 0
		@curDelay = 0
		@dirty = true
		if @links[@curImage] != null
			@canvas.style.cursor = "pointer"
			@canvas.title = @links[@curImage]
		else
			@canvas.style.cursor = "default"
			@canvas.title = ""

	delay: () =>
		@curDelay += 1
		if @curDelay>(30*@delayTime)
			@swap()

	update: () =>
		@curAlpha += (1-@curAlpha)*.05
		if Math.round(@curAlpha*1000)>=1000
			@curAlpha=1
			@dirty = false
			if @alternateTransitions
				@transition += 1
				if @transition > 5
					@transition=0
		@render(@imagens[@curImage])


	render: (image) =>
		cx = @canvas.getContext '2d'
		x = @canvas.width*.5
		y = @canvas.height*.5

		switch @transition
			when 0 # fade in
				cx.globalAlpha = @curAlpha
				cx.drawImage image,x-image.width*.5,y-image.height*.5
			when 1 # stretch horizontal
				cx.globalAlpha = @curAlpha
				cx.drawImage image,0,0, image.width,image.height,
						x-image.width*@curAlpha*.5, y-image.height*.5,
						image.width*@curAlpha, image.height
			when 2 #cortina
				cx.drawImage image,0,0, image.width,image.height,
						x-image.width*.5,y-image.height*.5,
						image.width*@curAlpha, image.height
			when 3 # central
				cx.globalAlpha = @curAlpha
				cx.drawImage image, image.width*.5*(1-@curAlpha),image.height*.5*(1-@curAlpha),
						image.width*@curAlpha,image.height*@curAlpha,
						x-image.width*@curAlpha*.5,y-image.height*@curAlpha*.5,
						image.width*@curAlpha, image.height*@curAlpha
			when 4 # bonitao 1
				if @recs == undefined
					@B = 64
					@recs = []
					@recX = @canvas.width-@B
					@recY = -@B
					@recAddBloco = true
					@lastRec = false
				if @recAddBloco
					@recY += @B
					if @recY>@canvas.height
						if @recX<0
							@recAddBloco = false
							@lastRec = @recs[@recs.length-1]
						@recY = 0
						@recX -= @B
					@recs.push {
							x:@recX
							y:@recY
							z:0
						}
				for box in @recs
					do (box) =>
						box.z += (1-box.z) * .13
						xa = box.x+@B*.5-@B*.5*box.z
						ya = box.y+@B*.5-@B*.5*box.z
						xb = @B*box.z
						yb =  @B*box.z
						xa = 0 if xa<0
						ya = 0 if ya<0
						xb = 0 if xb<0
						yb = 0 if yb<0
						cx.drawImage image,
							xa, ya,
							xb,yb,
							xa, ya,
							xb,yb
				@curAlpha = 0
				if @lastRec
					if Math.round(@lastRec.z*1000)>=1000
						@recs = undefined
						@curAlpha = 1
			when 5 # bonitao 2
				if @recs == undefined
					@B = 64
					@ZERO = 0
					if @canvas.width%@B > 0
						@ZERO = @canvas.width - (1+Math.round(@canvas.width/@B))*@B
					@recs = []
					@recX = @canvas.width-@B
					@recY = -@B
					@recAddBloco = true
					@lastRec = false
					if @lastImageRendered == undefined
						@lastImageRendered = document.createElement "canvas"
						@lastImageRendered.width = @canvas.width
						@lastImageRendered.height = @canvas.height
					lCx = @lastImageRendered.getContext '2d'
					lCx.drawImage @canvas,0,0
				if @recAddBloco
					dx = @recX
					dx = 0 if dx<0
					@recs.push
							x:dx
							y:@recY
							z:0
					@recY += @B
					if @recY>@canvas.height
						@recY = 0
						@recX -= @B
						if @recX<@ZERO
							@recAddBloco = false
							@lastRec = @recs[@recs.length-1]
							#alert @lastRec.x
				cx.strokeStyle = "#dfd"
				cx.globalAlpha = 1
				cx.drawImage @lastImageRendered,0,0
				cx.lineWidth = 2
				for box in @recs
					do (box) =>
						box.z += (1-box.z) * .13
						cx.globalAlpha = 1
						###
						cx.drawImage image,
							box.x+@B*.5-@B*.5*box.z, box.y+@B*.5-@B*.5*box.z,
							@B*box.z,@B*box.z,
							box.x+@B*.5-@B*.5*box.z, box.y+@B*.5-@B*.5*box.z,
							@B*box.z,@B*box.z
						###
						xa = box.x+@B*.5-@B*.5*box.z
						ya = box.y+@B*.5-@B*.5*box.z
						xb = @B*box.z
						yb =  @B*box.z
						xa = 0 if xa<0
						ya = 0 if ya<0
						xb = 0 if xb<0
						yb = 0 if yb<0
						cx.drawImage image,
							xa, ya,
							xb,yb,
							xa, ya,
							xb,yb
						cx.globalAlpha = 1 - box.z
						#cx.strokeRect box.x+1,box.y+1, @B-2,@B-2
						xa = box.x+1
						ya = box.y+1
						xa = 0 if xa<0
						ya = 0 if ya<0
						if @recs.length>1
							cx.strokeRect xa,ya, @B-2,@B-2
				@curAlpha = 0
				if @lastRec
					if Math.round(@lastRec.z*1000)>=1000
						@recs = undefined
						@curAlpha = 1
						cx.globalAlpha = 1
						cx.lineWidth = 0



	addEvent: (target, name,func) ->
		if target.attachEvent
			return target.attachEvent 'on'+name, func
		else
			return target.addEventListener name, func

# gerencia as instâncias na página
if window.cw_instances == undefined
	window.cw_instances = 0
window.cw_instances += 1

# nome da instância
name = "CardWidget_" + window.cw_instances

# código HTML principal do widget
slides_seta_data = "data:image/png;base64,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"
try
	if not slides_seta == undefined
		slides_seta_data = slides_seta
catch err

document.write "<aside id=\""+name+"\">"+
	"<style type=\"text/css\" scoped>"+
	"#"+name+"{\n"+
	"position:relative;\n"+
	"}\n"+
	"</style>"+
	"<canvas id=\""+name+"_canvas\">"+
	"Navegador não compatível com W3C."+
	"</canvas>"+

	"<style type=\"text/css\" scoped>"+
	".wslider_seta_flip {"+
	"	-moz-transform: scaleX(-1);"+
	"	-o-transform: scaleX(-1);"+
	"	-webkit-transform: scaleX(-1);"+
	"	transform: scaleX(-1);"+
	"	filter: FlipH;"+
	"	-ms-filter: \"FlipH\";"+
	"}"+
	""+
	".wslider_seta {"+
	"	position: absolute;"+
	"	top: 50%; margin-top: -64px;"+
	"	width: 128px; height: 128px;"+
	"	text-decoration: none;"+
	"	transition: opacity 1s;"+
	"	-webkit-transition: opacity 1s;"+
	"	opacity:0.0;"+
	"	background-image: url("+
	slides_seta_data+
	");"+
	"}"+
	""+
	".wslider_seta:hover {"+
	"	opacity:1.0;"+
	"}"+
	"</style>"+
	"<a id=\"wslider_seta_r_"+name+"\" class=\"wslider_seta wslider_seta_flip\" style=\"left: 2px;\" href=\"javascript:var w___nothing=0;\">&nbsp;</a>"+
	"<a id=\"wslider_seta_a_"+name+"\" class=\"wslider_seta\" style=\"right: 2px;\" href=\"javascript:var w___nothing=0;\">&nbsp;</a>"+

	"</aside>"

# run
new CardWidget(name,slides,slides_path)
