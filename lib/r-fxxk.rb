class BrainFuck
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
    cur = 0
    inv = operations.invert
    reg = Regexp.compile "(#{operations.values.map{|v| Regexp.quote(v) }.join('|')})"
    dst = ''
    while matches = reg.match(src, cur)
      op = inv[matches[1]]
      dst += self.class.bf_mapping[op]
      cur = src.index(reg, cur) + matches[1].length
    end
    dst
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
        next_cur = src.index(self.class.bf_mapping[:cls], cur) + 1 if cell[ptr] == 0
      when :cls
        next_cur = src.rindex(self.class.bf_mapping[:opn], cur)
      end
      cur = next_cur || src.index(reg, cur) + matches[1].length
    end
    output.join
  end

  class << self
    BrainFuck.default_mapping.keys.each do |op|
      define_method(op) do |val|
        default_mapping[op] = val
      end
    end
  end
end
