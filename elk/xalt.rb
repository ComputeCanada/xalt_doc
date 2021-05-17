require 'logstash-event'
event_hash = {'libA' => [['lib1', '0'], ['lib2', '0'], ['lib3', '0']], 'k_test' => 'v_test', '@timestamp' => '2021-05-17T16:30:59Z', '@version' => '1'}

event = LogStash::Event.new(event_hash)
puts event.get['libA'] #.each {|elem| puts elem.class}
event.set('libA', event.get('libA').map! {|elem| elem[0]})
to_keep = ['libA', '@timestamp', '@version']
event.to_hash.each_key do |key|
    if not to_keep.include?(key)
        event.remove(key)
    end
end

puts event.to_hash