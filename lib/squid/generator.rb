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
      (1..units).each do |unit|
        (unit..units).each do |span|
          comma = (unit != span or units != span) ? ',' : ' {'
          grid += <<-eos
.span-#{unit}-of-#{span}#{comma}
          eos
        end
      end
      grid += <<-eos
  display: inline-block;
  vertical-align: top;
  margin-left: #{margin}%;
  margin-right: -.273em;
  *zoom: 1;
  overflow: hidden;
  *overflow: visible;
}
      eos
			(1..units).each	do |unit|
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

// Generated at http://squishygrid.com

$grid_columns    : 12 !default;
$grid_gutters    : 2.5% !default;
$grid_breakpoint : 620 !default;

@mixin grid($gutters: null) {

  $grid_gutters: $grid_gutters;

  @if ($gutters != null) {
    $grid_gutters: $gutters;
  }

  @if $grid_gutters == 0 {
    width: 100%;
    margin-left: 0;
  }
  @else {
    width: 100 + $grid_gutters;
    margin-left: -$grid_gutters;
    > * {
      margin-left: $grid_gutters;
    }
  }
}

@mixin span($span: null, $columns: null, $gutters: null, $breakpoint: null) {

  $grid_columns   : $grid_columns;
  $grid_gutters   : $grid_gutters;
  $grid_breakpoint: $grid_breakpoint;

  @if ($columns != null) {
    $grid_columns: $columns;
  }
  @if ($span == null) {
    $span: $grid_columns;
  }
  @if $gutters != null {
    $grid_gutters: $gutters;
  }
  @if $breakpoint != null {
    $grid_breakpoint: $breakpoint;
  }

  display: inline-block;
  vertical-align: top;
  *zoom: 1;
  overflow: hidden;
  *overflow: visible;
  width: 100% - $grid_gutters;
  margin-right: -.273em;

  @media (min-width: ($grid_breakpoint / 16) +  em) {
    @if $grid_gutters == 0 {
      width: $span * (100.0% / $grid_columns);
      margin-left: 0;
    }
    @else {
      width: (100% - ($grid_columns * $grid_gutters)) / $grid_columns * $span + (($span - 1) * $grid_gutters);
      margin-left: $grid_gutters;
    }
  }
}

@mixin offset($offset: 0, $columns: null, $gutters: null, $breakpoint: null) {

  $grid_columns   : $grid_columns;
  $grid_gutters   : $grid_gutters;
  $grid_breakpoint: $grid_breakpoint;

  @if ($columns != null) {
    $grid_columns: $columns;
  }

  @if $gutters != null {
    $grid_gutters: $gutters;
  }

  @if $breakpoint != null {
    $grid_breakpoint: $breakpoint;
  }

  margin-left: 0;

  @media (min-width: ($grid_breakpoint / 16) +  em) {
    margin-left: (100.0 / $grid_columns) * $offset + $grid_gutters;
  }
}

        eos

      elsif output == 'less'

        grid = <<-eos
/* -------------------------------------------------
** Squishygrid LESS Mixins
** ---------------------------------------------- */

// Generated at http://squishygrid.com

@grid_columns    : 12;
@grid_gutters    : 2.5%;
@grid_breakpoint : 620;

.grid(@gutters: ~'') {

  & when not (@gutters) {
    @grid_gutters: @gutters;
  }

  width: 100% + @grid_gutters;
  margin-left: -@grid_gutters;
  > * {
    margin-left: @grid_gutters;
  }

  & when (@grid_gutters = 0 ) {
    width: 100%;
    margin-left: 0;
  }
}

.span(@span: ~'', @columns: ~'', @gutters: ~'', @breakpoint: ~'') {

  & when (@columns) {
    @grid_columns: @columns;
  }

  & when not (@span) {
    @span: @grid_columns;
  }

  & when (@gutters) {
    @grid_gutters: @gutters;
  }

  & when (@breakpoint) {
    @grid_breakpoint: @breakpoint;
  }

  display: inline-block;
  vertical-align: top;
  *zoom: 1;
  overflow: hidden;
  *overflow: visible;
  width: 100% - @grid_gutters;
  margin-right: -.273em;

  @media (min-width: unit((@grid_breakpoint / 16), em)) {
    width: (100% - (@grid_columns * @grid_gutters)) / @grid_columns * @span + ((@span - 1) * @grid_gutters);
    margin-left: @grid_gutters;

    & when (@grid_gutters = 0) {
      width: @span * (100.0% / @grid_columns);
      margin-left: 0;
    }
  }
}

.offset(@offset: 0, @columns: ~'', @gutters: ~'', @breakpoint: ~'') {

  & when not (@columns) {
    @grid_columns: @columns;
  }

  & when not (@gutters) {
    @grid_gutters: @gutters;
  }

  & when not (@breakpoint) {
    @grid_breakpoint: @breakpoint;
  }

  margin-left: 0;

  @media (min-width: unit((@grid_breakpoint / 16), em)) {
    margin-left: (100.0 / @grid_columns) * @offset + @grid_gutters;
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