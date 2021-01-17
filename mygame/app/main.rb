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

SCORECOUNT = {
  'cow' => 0,
  'veggies' => 0,
  'car' => 0,
  'bus' => 0,
  'plastic bag' => 0,
  'tote' => 0,
  'new shirt' => 0,
  'thrifted' => 0,
  'bottled water' => 0,
  'tap water' => 0
}

WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

@pair = rand(5)
@boxes = []
@height = 0
@footprint = 0
@start = true
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
    
    # calculating what's a good score: 15 and below bad, to 22 average, 22 above getting better
    if @height <= 15
      args.outputs.sprites << [0, 0, WINDOW_WIDTH, WINDOW_WIDTH, 'sprites/square/red.png']
      args.outputs.labels << [640, 400, 'Try to think of ways you can be sustainable in your life.', 10, 1, 255, 255, 255]
      # insert personalized message about the things they chose
    elsif @height <= 22
      args.outputs.sprites << [0, 0, WINDOW_WIDTH, WINDOW_WIDTH, 'sprites/square/yellow.png']
      args.outputs.labels << [640, 400, 'You can be more sustainable and make a change!', 10, 1, 255, 255, 255]
      # insert personalized message about the things they chose
    else
      args.outputs.sprites << [0, 0, WINDOW_WIDTH, WINDOW_WIDTH, 'sprites/square/green.png']
      args.outputs.labels << [640, 400, 'Good try, keep making sustainable choices.', 10, 1, 255, 255, 255]
      # insert personalized message about the things they chose
    end
    args.outputs.labels << [640, 550, 'GAME OVER!', 10, 1, 255, 255, 255]
    args.outputs.labels << [640, 500, 'You\'ve exceeded the maximum carbon footprint.', 10, 1, 255, 255, 255]
    args.outputs.labels << [640, 450, "Your score was: #{@height}", 10, 1, 255, 255, 255]

    args.outputs.labels << [640, 350, "Cows: #{SCORECOUNT['cow']}", 10, 1, 255, 255, 255]
    #TODO something with scorecount of each item
               
    # play again button
    args.outputs.sprites << [WINDOW_WIDTH / 2 - 150, 75, 300, 100, 'sprites/square/black.png']
    args.outputs.labels << [640, 150, "Play Again?", 10, 1, 255, 255, 255]

    if args.inputs.mouse.click
      if args.inputs.mouse.point.inside_rect? [WINDOW_WIDTH / 2 - 50, 75, WINDOW_WIDTH / 2 - 50 + 100, 75 + 100]
        @start = true
        @end = false
        @height = 0
        @footprint = 0
        @boxes = []
        SCORECOUNT.each { |k, v| SCORECOUNT[k] = 0 } 
      end
    end

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
        SCORECOUNT[item] += 1
      end
    end

    @end = true if @footprint > 100
  end
end
