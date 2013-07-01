# Render and customize QR codes from Rails 3 applications

This gem extends rqrcode-rails published by samvincent, supporting the output in either SVG or PNG, JPEG, and GIF formats and

providing new options to set background image combined with QR code image.


## Installation

Add the following to your `Gemfile`.

    gem 'custom_rqrcode'

If you want to use the PNG, JPEG or GIF format, you will have to have **ImageMagick** installed on your system.
You will also want to add the **mini_magick** gem to your application's `Gemfile`.

    gem 'mini_magick'

## How to use

In your controller actions, you could return a QR code that links to the current page like this:

```ruby
bg_image = Rails.root.join("app").to_s + ActionController::Base.helpers.asset_path("images/bg_image.png")
respond_to do |format|
  format.html
  format.svg  { render :qrcode => request.url, :level => :l, :unit => 10 }
  format.png  { render :qrcode => request.url, :bg => bg_image, :bsize => "200x100", :gravity => "center" }
  format.gif  { render :qrcode => request.url }
  format.jpeg { render :qrcode => request.url }
end
```
  
#### Options:

* `:size`    – This controls how big the QR Code will be. Smallest size will be chosen by default. Set to maintain consistent size.
* `:level`   – The error correction level, can be:
  * Level `:l` 7%  of code can be restored
  * Level `:m` 15% of code can be restored
  * Level `:q` 25% of code can be restored
  * Level `:h` 30% of code can be restored (default :h) 
* `:offset`  – Padding around the QR Code (e.g. 10)
* `:unit`    – How many pixels per module (e.g. 11)
* `:fill`    – Background color (e.g "ffffff" or :white)
* `:color`   – Foreground color for the code (e.g. "000000" or :black)
* `:bg`      – Background image to be combined with QR code image (e.g. "./img/000.png")
* `:bsize`   – Resize background image (e.g. "300x200")
* `:gravity` – Location where QR code image will be put on the background image (e.g. "center", "north", "south")

## About

This project was modified from samvincent's project [rqrcode-rails3](https://github.com/samvincent/rqrcode-rails3)

QR codes are encoded by [rqrcode](https://github.com/whomwah/rqrcode)
