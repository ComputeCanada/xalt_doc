$KEEP = ['@timestamp', '@version', 'libA', 'type']

def filter(event)
    flatten_libA(event)
    remove_fields(event)
    return [event]
end

def flatten_libA(event)
    event.set('libA', event.get('libA').map! {|elem| elem[0]})
end

def remove_fields(event)
    event.to_hash.each_key do |key|
        if not $KEEP.include?(key)
            event.remove(key)
        end
    end
end
