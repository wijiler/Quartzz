// #import "uniform"; not needed yet and may never be
fc:     u64 = 0;
rc:     u64 = 0;
sym:    [..] string;
parse_lit :: (token:Token) -> Node {
            expr:Expression;
            children:[..] Node;
            expr.Literal = LiteralExpr.{token.expr};
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
                scope_begin := find_indexof_from_index(toks,it,.LBRACK);
                scope_end := find_indexof_from_index(toks,it,.RBRACK);
                if scope_end == 0 {
                    print("scope for function % does not exist",toks[it + 1].expr);
                    exit(1);
                }               
                // almost all operations should be done on this array
                tslice := slice_arr(toks,cast(int) scope_begin,cast(int) scope_end);
                fslice := slice_arr(toks,it,cast(int) scope_end);
                ft:ftag = .FT_NONE;
                for 0..fslice.count -1 {
                    if fslice[it].type ==  cast(u8) TokenType.MAIN_TAG {
                        ft = .FT_ENTRY;
                    }
                }
                children := parse_node(tslice);
                expr:Expression;
                fc += 1;
                symbol:string;
                if ft=={
                    case .FT_NONE; symbol = sprint("LSF%",fc);
                    case .FT_ENTRY; symbol = "main";
                    case .FT_META; symbol = sprint("MSF%",fc);
                    case .FT_ASYNC; symbol = sprint("TSF%",fc);
                }
                expr.Function = FunctionExpr.{ft,symbol,fc};
                node := Node.{expr,children};
                return node,scope_end;
}

parse_var :: (toks:[..] Token,it:int) -> Node,int {
    expr:Expression;
    children:[..] Node;
    nc:[..] Node;
    immutable:bool;
    immutable = toks[it + 2].type != cast(u8) TokenType.EQUALS;
    expr.Var = VarExpr.{toks[it + 1].expr,immutable};
    if !immutable { return Node.{expr,children},2; }
    val:Expression;
    val.Literal = LiteralExpr.{toks[it + 3].expr};
    array_add(*children,Node.{val,nc});
    return Node.{expr,children},4;
}

#import "parser";
#import "lexer";
#import "Basic";
#import "arrextras";