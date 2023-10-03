slice_arr :: (arr:[..] $T,from:int,to:int) -> [..] T {
        assert(arr.count - 1 > 1,"tried to pass an invalid array to slice_arr");
        assert(to <= arr.count - 1,"passed invalid to adress");
        a:[..] T;
        for from..to {
                array_add(*a,arr[it]);
        }
        return a;
}

find_indexof_from_index :: (arr:[..] Token,from:int,type:TokenType) -> u64  {
        assert(arr.count - 1 > 1,"tried to pass an invalid array to fiofi");
        assert(from <= arr.count - 1,"passed invalid to address");
        for from..arr.count {
                if arr[it].type == cast(u8) type {
                        return cast(u64) it;
                }
        }
        return 0;
}

#import "Basic";
#import "lexer";