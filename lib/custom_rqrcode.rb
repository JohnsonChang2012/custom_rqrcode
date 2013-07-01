require 'action_controller'
require 'rqrcode'
require 'rqrcode-rails3/size_calculator.rb'
require 'rqrcode-rails3/renderers/svg.rb'

module RQRCode
	Mime::Type.register "image/svg+xml", :svg  unless Mime::Type.lookup_by_extension(:svg)
	Mime::Type.register "image/png",     :png  unless Mime::Type.lookup_by_extension(:png)
	Mime::Type.register "image/jpeg",    :jpeg unless Mime::Type.lookup_by_extension(:jpeg)
	Mime::Type.register "image/gif",     :gif  unless Mime::Type.lookup_by_extension(:gif)

	extend SizeCalculator

	ActionController::Renderers.add :qrcode do |string, options|
		format = self.request.format.symbol
		size   = options[:size]  || RQRCode.minimum_qr_size_from_string(string)
		level  = options[:level] || :h

		bg     = options[:bg] || false

		qrcode = RQRCode::QRCode.new(string, :size => size, :level => level)
		svg    = RQRCode::Renderers::SVG::render(qrcode, options)

		data   = \
		if format && format == :svg
		svg
		else
			image = MiniMagick::Image.read(svg) { |i| i.format "svg" }
			image.format format

			#image = RQRCode::mergeImages(image, bg) if bg
			if bg
				bg_image = MiniMagick::Image.open bg
				gravity = options[:gravity] || "north"
				image =  bg_image.composite(image) do |c|
					c.gravity gravity
				end
			end

		image.to_blob
		end

		self.response_body = render_to_string(:text => data, :template => nil)
	end

	def mergeImages(image, bg, options)
		bg_image = MiniMagick::Image.open bg
		gravity = options[:gravity] || "north"
		bg_image.composite(image) do |c|
			c.gravity gravity
		end
	end
end
