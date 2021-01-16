# frozen_string_literal: true

COLOURS = [['black', 'blue'], ['gray', 'green'], ['indigo', 'orange'], ['red', 'violet'], ['yellow', 'white']]

def tick args
  pair = 1

  y = 250
  COLOURS[pair].each_with_index do |colour, index|
    args.outputs.sprites << [50, y + (index * 125), 100, 100, "sprites/square/#{colour}.png"]
  end

  if args.inputs.mouse.button_left
    if args.inputs.mouse.x.between?(50, 150) && args.inputs.mouse.y.between?(250, 350)
      args.outputs.labels << [640, 500, "mouse clicked #{COLOURS[pair][0]} at #{args.inputs.mouse.point}"]
    elsif args.inputs.mouse.x.between?(50, 150) && args.inputs.mouse.y.between?(375, 475)
      args.outputs.labels << [640, 500, "mouse clicked #{COLOURS[pair][1]} at #{args.inputs.mouse.point}"]
    end
  end
end
