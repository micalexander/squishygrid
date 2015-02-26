module Squid
	class Generator

		def generate_grid_styles units, margin, breakpoint, output

			grid = <<-eos
.grid {
  width: 102.5%;
  margin-left: -2.5%;
  &.compact {
    width: 100%;
    margin-left: 0;
  }
}
		eos
			(1..units).each	do |unit|
        (unit..units).each do |span|
          comma = units != span ? ',' : ' {'
          grid += <<-eos
.span-#{unit}-of-#{span}#{comma}
          eos
        end
        grid += <<-eos
  display: inline-block;
  vertical-align: top;
  margin-left: #{margin}%;
  *zoom: 1;
  overflow: hidden;
  *overflow: visible;
}
        eos

        (unit..units).each do |span|

          width = (100 - (span * margin)) / span * unit + ((unit - 1) * margin)

          full_width = (100.0 / span) * unit

          grid += <<-eos
.span-#{unit}-of-#{span} {
  width: #{width}%;
  &.offset-#{unit}-of-#{span} {
    margin-left: #{full_width + margin}%;
    .compact > & {
      margin-left: #{full_width}%;
    }
  }
  .compact > & {
    width: #{full_width}%;
    margin-left: 0;
  }
}
					eos

				end
			end

			grid += <<-eos
.grid,
.grid.compact {
  @media (max-width: #{breakpoint}px) {
    width: 100%;
    margin-left: 0;
  }
}
[class*=' span-'],
[class*=' offset-'] {
  .grid &,
  .grid.compact > & {
    @media (max-width: #{breakpoint}px) {
      width: 100%;
      margin-left: 0;
    }
  }
}
      eos
		end

    def generate_grid_html units

      i = 0;
      grid = <<-eos
<div class="grid">
      eos
      units.times do |unit|
        i += 1;
        grid += <<-eos
  <div class="span-#{i}-of-#{units}">
  </div>
        eos
      end
        grid += <<-eos
</div>
        eos
    end
    def mixin_grid output
      if output == 'sass'

        grid = <<-eos
/* -------------------------------------------------
** Squishygrid Sass Mixins
** ---------------------------------------------- */

@mixin grid($margin-left: 2.5%) {
  @if ($margin-left == compact or $margin-left == 0) {
    width: 100%;
    margin-left: 0;
  }
  @else {
    width: 100 + $margin-left;
    margin-left: -$margin-left;
    > * {
      margin-left: $margin-left;
    }
  }
}

@mixin span($unit: 1, $span: 1, $margin-left: 2.5%, $breakpoint: 620px) {
  display: inline-block;
  vertical-align: top;
  @if ($margin-left == compact or $margin-left == 0) {
    width: $unit * (100.0% / $span);
    margin-left: 0;
  }
  @else {
    width: (100 - ($span * $margin-left)) / $span * $unit + (($unit - 1) * $margin-left);
    margin-left: $margin-left;
  }
  *zoom: 1;
  overflow: hidden;
  *overflow: visible;
  @media (max-width: $breakpoint) {
    width: 100 - $margin-left;
  }
}

@mixin offset($offset: 0, $amount: 0, $margin-left: 2.5%, $breakpoint: 620px) {
  margin-left: (100.0 / $amount) * $offset + $margin-left;
  @media (max-width: $breakpoint) {
    margin-left: 0;
  }
}
        eos

      elsif output == 'less'

        grid = <<-eos
/* -------------------------------------------------
** Squishygrid LESS Mixins
** ---------------------------------------------- */

.grid(@margin-left: 2.5%) {
  width: 100 + @margin-left;
  margin-left: -@margin-left;
  > * {
    margin-left: @margin-left;
  }
  & when (@margin-left = compact) {
    width: 100%;
    margin-left: 0;
    > * {
      margin-left: 0;
    }
  }
  & when (@margin-left = 0) {
    width: 100%;
    margin-left: 0;
    > * {
      margin-left: 0;
    }
  }
}

.span(@unit: 1, @span: 1, @margin-left: 2.5%, @breakpoint: 620px) {
  display: inline-block;
  vertical-align: top;
  width: (100 - (@span * @margin-left)) / @span * @unit + ((@unit - 1) * @margin-left);
  margin-left: @margin-left;
  & when (@margin-left == compact) {
    width: @unit * (100.0% / @span);
    margin-left: 0;
  }
  & when (@margin-left == 0) {
    width: @unit * (100.0% / @span);
    margin-left: 0;
  }
  *zoom: 1;
  overflow: hidden;
  *overflow: visible;
  @media (max-width: @breakpoint) {
    width: 100 - @margin-left;
  }
}

.offset(@offset: 0, @amount: 0, @margin-left: 2.5%, @breakpoint: 620px) {
  margin-left: (100.0 / @amount) * @offset + @margin-left;
  @media (max-width: @breakpoint) {
    margin-left: 0;
  }
}
        eos

      end
    end

    def get_grid units, margin, output, breakpoint, mixin

      grid_html   = self.generate_grid_html units.to_i
      grid_mixin  = self.mixin_grid output

      if mixin == 'on'
        return grid_html, grid_mixin
      end

      grid_styles = self.generate_grid_styles units.to_i, margin.to_f, breakpoint, output

			if output == 'css'

				return grid_html, Sass::Engine.new(grid_styles, :syntax => :scss, :style => :expanded).render
			else

        grid_styles += grid_mixin

				return grid_html, grid_styles
			end

		end
	end
end