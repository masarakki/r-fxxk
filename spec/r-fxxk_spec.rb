require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Ook < BrainFuck
  nxt 'Ook. Ook?'
  prv 'Ook? Ook.'
  inc 'Ook. Ook.'
  dec 'Ook! Ook!'
  put 'Ook! Ook.'
  get 'Ook. Ook!'
  opn 'Ook! Ook?'
  cls 'Ook? Ook!'
end

def src(file)
  open(File.expand_path(File.dirname(__FILE__) + "/test_data/#{file}")).read
end

describe BrainFuck do
  context 'default BrainFuck' do
    subject { BrainFuck.new }
    its(:nxt) { should eq '>' }
    its(:prv) { should eq '<' }
    its(:inc) { should eq '+' }
    its(:dec) { should eq '-' }
    its(:put) { should eq '.' }
    its(:get) { should eq ',' }
    its(:opn) { should eq '[' }
    its(:cls) { should eq ']' }
    it "fuck(hello.bf) should be 'Hello World\\n'" do
      subject.fuck(src('hello.bf')).should eq "Hello World!\n"
    end
  end

  context 'customize in initialize' do
    subject { BrainFuck.new(nxt: 'M', prv: 'O', inc: 'N', dec: 'A', get: 'm', put: 'o', opn: 'n', cls: 'a') }
    its(:nxt) { should eq 'M' }
    its(:prv) { should eq 'O' }
    its(:inc) { should eq 'N' }
    its(:dec) { should eq 'A' }
    its(:get) { should eq 'm' }
    its(:put) { should eq 'o' }
    its(:opn) { should eq 'n' }
    its(:cls) { should eq 'a' }
    it "fuck(hello.mona) should be 'Hello World\\n'" do
      subject.fuck(src('hello.mona')).should eq "Hello World!\n"
    end
    it "translate(BrainFuck.new, hello.bf) should == hello.mona" do
      subject.translate(BrainFuck, src('hello.bf')).strip.should eq src('hello.mona').strip
    end
  end

  context 'customized class' do
    subject { Ook.new }
    its(:nxt) { should eq 'Ook. Ook?' }
    its(:prv) { should eq 'Ook? Ook.' }
    its(:inc) { should eq 'Ook. Ook.' }
    its(:dec) { should eq 'Ook! Ook!' }
    its(:put) { should eq 'Ook! Ook.' }
    its(:get) { should eq 'Ook. Ook!' }
    its(:opn) { should eq 'Ook! Ook?' }
    its(:cls) { should eq 'Ook? Ook!' }
    it "fuck(hello.ook) should be 'Hello World\\n'" do
      subject.fuck(src('hello.ook')).should eq "Hello World!\n"
    end
  end

end
