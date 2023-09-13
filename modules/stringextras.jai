string_remove_by_index :: (string_pointer:*string, index: s64) {
    assert(index >= 0);
    assert(index < string_pointer.count);

    s := <<string_pointer;

    for i : index..s.count-2
        s[i] = s[i+1];

    string_pointer.count -= 1;
}

#import "Basic";