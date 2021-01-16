# frozen_string_literal: true

COLOURS = [['cow', 'veggies'],
           ['car', 'bus'],
           ['plastic bag', 'tote'],
           ['new shirt', 'thrifted'],
           ['bottled water', 'tap water']].freeze
SCORES = {
  'cow' => [8, 12],
  'veggies' => [2, 7],
  'car' => [15, 25],
  'bus' => [10, 16],
  'plastic bag' => [5, 10],
  'tote' => [1, 4],
  'new shirt' => [8, 12],
  'thrifted' => [4, 7],
  'bottled water' => [8, 10],
  'tap water' => [0, 3]
}.freeze

WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

@pair = rand(5)
@boxes = []
@height = 0
@footprint = 0
@start = false
@end = false

def tick args
  # start screen
  if @start
    args.outputs.sprites << [0, 0, WINDOW_WIDTH, WINDOW_WIDTH, 'sprites/square/gray.png']
    args.outputs.labels << [WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2 + 150, 'dis a game', 10, 1]

    # start button
    args.outputs.sprites << [WINDOW_WIDTH / 2 - 300, 150, 250, 150, 'sprites/isometric/green.png']

    # instructions button
    args.outputs.sprites << [WINDOW_WIDTH / 2 + 50, 150, 250, 150, 'sprites/isometric/red.png']

    # link to HYPE page
    args.outputs.sprites << [WINDOW_WIDTH / 2 - 50, 75, 100, 100, 'sprites/circle/blue.png']

    if args.inputs.mouse.click
      if args.inputs.mouse.point.inside_rect? [WINDOW_WIDTH / 2 - 300, 150, WINDOW_WIDTH / 2 - 300 + 250, 150 + 150]
        @start = false
      elsif args.inputs.mouse.point.inside_rect? [WINDOW_WIDTH / 2 + 50, 150, WINDOW_WIDTH / 2 + 50 + 250, 150 + 150]
        # TODO: instructions page
      elsif args.inputs.mouse.point.inside_rect? [WINDOW_WIDTH / 2 - 50, 75, WINDOW_WIDTH / 2 - 50 + 100, 75 + 100]
        # TODO: page with link to HYPE project
      end
    end

  # end screen
  elsif @end
    # TODO: end screen

  # gameplay
  else
    y = 250
    COLOURS[@pair].each_with_index do |colour, index|
      args.outputs.sprites << [50, y + (index * 125), 100, 100, "sprites/square/#{colour}.png"]
    end
    args.outputs.labels << [1260, 690, "Tower height: #{@height}", 2, 2]
    args.outputs.labels << [1260, 640, "Carbon footprint: #{@footprint}", 2, 2]

    @boxes.each_with_index do |box, index|
      x = WINDOW_WIDTH / 2 + 100
      y = WINDOW_HEIGHT / 2 - 200 * index

      if y < -199
        @boxes.delete_at(index)
      else
        args.outputs.sprites << [x, y, 200, 200, "sprites/square/#{box}.png"]
      end
    end

    # making choice
    if args.inputs.mouse.click
      if args.inputs.mouse.point.inside_rect? [50, 250, 100, 100]
        choice = 0
      elsif args.inputs.mouse.point.inside_rect? [50, 375, 100, 100]
        choice = 1
      else
        choice = -1
      end

      if choice > -1
        item = COLOURS[@pair][choice]
        @boxes.insert(0, item)
        @height += 1
        @footprint += SCORES[item][0] + rand(SCORES[item][1] - SCORES[item][0])
        @pair = rand(5)
      end
    end
  end
end
