class Brainfuck
  def initialize(options = {})
    self.class.default_mapping.each do |key, default|
      operations[key] = options.has_key?(key) ? options[key] : default
    end
  end

  def self.bf_mapping
    @bf_operations ||= {nxt: '>', prv: '<', inc: '+', dec: '-', put: '.',  get: ',', opn: '[', cls: ']' }
  end

  def self.default_mapping
    @default_mapping ||= bf_mapping.clone
  end

  def operations
    @operations ||= {}
  end

  default_mapping.keys.each do |op|
    define_method(op) do
      instance_variable_get(:@operations)[op]
    end
  end

  def compile(src)
    Brainfuck.new.translate(self, src)
  end

  def translate(other, src)
    other = other.new if other.kind_of?(Class)
    cur = 0
    inv = other.operations.invert
    reg = Regexp.compile "(#{other.operations.values.map{|v| Regexp.quote(v) }.join('|')})"
    dst = ''
    while matches = reg.match(src, cur)
      op = inv[matches[1]]
      dst += operations[op]
      cur = src.index(reg, cur) + matches[1].length
    end
    dst
  end

  def hello_world
    translate(Brainfuck, '>+++++++++[<++++++++>-]<.>+++++++[<++++>-]<+.+++++++..+++.[-]>++++++++[<++++>-]<.>+++++++++++[<+++++>-]<.>++++++++[<+++>-]<.+++.------.--------.[-]>++++++++[<++++>-]<+.[-]++++++++++.')
  end

  def fuck(src)
    src = compile(src)
    ptr = 0
    cur = 0
    cell = Array.new(3000) { 0 }
    output = []
    inv = self.class.bf_mapping.invert
    reg = Regexp.compile "(#{self.class.bf_mapping.values.map{|v| Regexp.quote(v) }.join('|')})"
    while matches = reg.match(src, cur)
      next_cur = nil
      case inv[matches[1]]
      when :nxt
        ptr += 1
      when :prv
        ptr -= 1
      when :inc
        cell[ptr] += 1
      when :dec
        cell[ptr] -= 1
      when :put
        output << cell[ptr].chr
      when :get
      when :opn
        if cell[ptr] == 0
          open_count = 1
          buf_cur = cur
          while open_count > 0
            open_count.times do
              next_cur = src.index(self.class.bf_mapping[:cls], buf_cur)
              open_count = src[buf_cur+1..next_cur].count(self.class.bf_mapping[:opn])
              buf_cur = next_cur
            end
          end
          next_cur = next_cur + 1
        end
      when :cls
        close_count = 1
        buf_cur = cur
        while close_count > 0
          close_count.times do
            next_cur = src.rindex(self.class.bf_mapping[:opn], buf_cur)
            close_count = src[next_cur..buf_cur-1].count(self.class.bf_mapping[:cls])
            buf_cur = next_cur
          end
        end
      end
      cur = next_cur || src.index(reg, cur) + matches[1].length
    end
    output.join
  end

  class << self
    Brainfuck.default_mapping.keys.each do |op|
      define_method(op) do |val|
        default_mapping[op] = val
      end
    end
  end
end

# For backwards compatibility.
BrainFuck = Brainfuck
