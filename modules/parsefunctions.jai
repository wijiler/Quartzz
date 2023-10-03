// #import "uniform"; not needed yet and may never be
fc:     u64 = 0;
rc:     u64 = 0;
parse_lit :: (token:Token) -> Node {
            expr:Expression;
            children:[..] Node;
            expr.Variable = LiteralExpr.{token.expr};
            node := Node.{expr,children};
            return node;

}
parse_return :: (toks: [..] Token,it:int) -> Node {
            children:[..] Node;
            array_add(*children,parse_lit(toks[it + 1]));
            expr:Expression;
            rc += 1;
            expr.Return = ReturnExpr.{rc};

            node := Node.{expr,children};
            return node;
}
parse_function :: (toks:[..] Token,it:int) -> Node,u64 {
                scope_end := find_indexof_from_index(toks,it,.RBRACK);
                if scope_end == 0 {
                    exit(1);
                }               
                // almost all operations should be done on this array
                tslice := slice_arr(toks,it,cast(int) scope_end);
                children := parse_node(tslice);
                expr:Expression;
                fc += 1;
                expr.Function = FunctionExpr.{fc};
                node := Node.{expr,children};
                return node,scope_end;
}

#import "parser";
#import "lexer";
#import "Basic";
#import "arrextras";