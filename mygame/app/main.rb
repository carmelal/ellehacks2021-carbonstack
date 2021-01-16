# frozen_string_literal: true

COLOURS = [['black', 'blue'], ['gray', 'green'], ['indigo', 'orange'], ['red', 'violet'], ['yellow', 'white']]
@pair = rand(5)

@boxes = []

def tick args
  y = 250
  COLOURS[@pair].each_with_index do |colour, index|
    args.outputs.sprites << [50, y + (index * 125), 100, 100, "sprites/square/#{colour}.png"]
  end

  @boxes.each_with_index { |box, index| args.outputs.sprites << [640, 500 - (200 * index), 200, 200, "sprites/square/#{box}.png"] unless 500 - (200 * index) < -200 }

  if args.inputs.mouse.click
    if args.inputs.mouse.point.inside_rect? [50, 250, 200, 200]
      # args.outputs.labels << [640, 500, "mouse clicked #{COLOURS[@pair][0]} at #{args.inputs.mouse.point}"]
      choice = 1
    elsif args.inputs.mouse.point.inside_rect? [50, 375, 200, 200]
      # args.outputs.labels << [640, 500, "mouse clicked #{COLOURS[@pair][1]} at #{args.inputs.mouse.point}"]
      choice = 0
    end
    @boxes.insert(0, COLOURS[@pair][choice])
    @pair = rand(5)
  end
end
