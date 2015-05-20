module Squid
	class Generator

		def generate_grid_styles columns, gutter, at, output

			grid = <<-eos
.grid {
  width: #{100 + gutter}%;
  margin-left: -#{gutter}%;
  &.compact {
    width: 100%;
    margin-left: 0;
  }
}
		eos
      (1..columns).each do |column|
        (column..columns).each do |span|
          comma = (column != span or columns != span) ? ',' : ' {'
          grid += <<-eos
.span-#{column}-of-#{span}#{comma}
          eos
        end
      end
      grid += <<-eos
  display: inline-block;
  vertical-align: top;
  margin-left: #{gutter}%;
  margin-right: -.273em;
  *zoom: 1;
  overflow: hidden;
  *overflow: visible;
}
      eos
			(1..columns).each	do |column|
        (column..columns).each do |span|

          width = (100 - (span * gutter)) / span * span + ((span - 1) * gutter)

          full_width = (100.0 / span) * span

          grid += <<-eos
.span-#{column}-of-#{span} {
  width: #{width}%;
  &.offset-#{column}-of-#{span} {
    margin-left: #{full_width + gutter}%;
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
  @media (max-width: #{at}px) {
    width: 100%;
    margin-left: 0;
  }
}
[class*=' span-'],
[class*=' offset-'] {
  .grid &,
  .grid.compact > & {
    @media (max-width: #{at}px) {
      width: 100%;
      margin-left: 0;
    }
  }
}
      eos
		end

    def generate_grid_html columns

      i = 0;
      grid = <<-eos
<div class="grid">
      eos
      columns.times do |span|
        i += 1;
        grid += <<-eos
  <div class="span-#{i}-of-#{columns}">
  </div>
        eos
      end
        grid += <<-eos
</div>
        eos
    end

    def mixin_grid columns, gutter, at, output
      if output == 'sass'

        grid = <<-eos
/* -------------------------------------------------
** Squishygrid Sass Mixins
** ---------------------------------------------- */

// Generated at http://squishygrid.com

$span   : #{columns}   !default;
$columns: #{columns}   !default;
$gutter : #{gutter}  !default;
$at     : #{at}  !default;

@mixin grid($gutter: $gutter) {

  @if $gutter == 0 {
    width: 100%;
    margin-left: 0;
  }
  @else {
    width: 100 + $gutter * 1%;
    margin-left: -$gutter * 1%;
    > * {
      margin-left: $gutter * 1%;
    }
  }
}

@mixin span($span: $span, $columns: $columns, $gutter: $gutter, $at: $at) {

  display: inline-block;
  vertical-align: top;
  *zoom: 1;
  overflow: hidden;
  *overflow: visible;
  width: 100 - $gutter * 1%;

  @media (min-width: ($at / 16) +  em) {
    @if $gutter == 0 {
      width: $span * (100.0% / $columns);
      margin-left: 0;
    }
    @else {
      width: (100 - ($columns * ($gutter * 1%))) / $columns * $span + (($span - 1) * ($gutter * 1%));
      margin-left: ($gutter * 1%);
    }
  }
}

@mixin offset($offset: 0, $columns: $columns, $gutter: $gutter, $at: $at) {

  margin-left: 0;

  @media (min-width: ($at / 16) +  em) {
    margin-left: (100.0 / $columns) * $offset + ($gutter * 1%);
  }
}
        eos

      elsif output == 'less'

        grid = <<-eos
/* -------------------------------------------------
** Squishygrid LESS Mixins
** ---------------------------------------------- */

// Generated at http://squishygrid.com

@span   : #{columns};
@columns: #{columns};
@gutter : #{gutter};
@at     : #{at};

.grid(@gutter: @gutter) {

  width: 100% + @gutter;
  margin-left: -@gutter;
  > * {
    margin-left: @gutter;
  }
  > a#main-content {
    margin-left: auto;
  }

  & when (@gutter = 0 ) {
    width: 100%;
    margin-left: 0;
  }
}

.span(@span: @span, @columns: @columns, @gutter: @gutter, @at: @at) {

  display: inline-block;
  vertical-align: top;
  *zoom: 1;
  overflow: hidden;
  *overflow: visible;
  width: 100% - @gutter;
  margin-right: -.273em;

  @media (min-width: unit((@at / 16), em)) {
    width: (100% - (@columns * @gutter)) / @columns * @span + ((@span - 1) * @gutter);
    margin-left: @gutter;

    & when (@gutter = 0) {
      width: @span * (100.0% / @columns);
      margin-left: 0;
    }
  }
}

.offset(@offset: 0, @columns: @columns, @gutter: @gutter, @at: @at) {

  margin-left: 0;

  @media (min-width: unit((@at / 16), em)) {
    margin-left: (100.0 / @columns) * @offset + @gutter;
  }
}
        eos

      end
    end

    def get_grid columns, gutter, at, output, mixin

      grid_html   = self.generate_grid_html columns.to_i
      grid_mixin  = self.mixin_grid columns, gutter, at, output

      if mixin == 'on'

        return grid_html, grid_mixin
      end

      grid_styles = self.generate_grid_styles columns.to_i, gutter.to_f, at, output

			if output == 'css'

				return grid_html, Sass::Engine.new(grid_styles, :syntax => :scss, :style => :expanded).render
			else

        grid_styles += grid_mixin

				return grid_html, grid_styles
			end

		end
	end
end