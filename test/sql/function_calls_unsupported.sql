begin;
    -- functions in this file are not supported yet

    create table account(
        id serial primary key,
        email varchar(255) not null
    );

    insert into public.account(email)
    values
        ('aardvark@x.com'),
        ('bat@x.com'),
        ('cat@x.com');

    -- functions which return a record
    create function returns_record()
        returns record language sql stable
    as $$ select id, email from account; $$;

    select jsonb_pretty(graphql.resolve($$
        query {
            returnsRecord {
                id
                email
                nodeId
                __typename
            }
        }
    $$));

    -- functions which accept a table tuple type
    create function accepts_table_tuple_type(rec public.account)
        returns int
        immutable
        language sql
    as $$
        select 1;
    $$;

    select jsonb_pretty(graphql.resolve($$
        query {
            acceptsTableTupleType
        }
    $$));

    -- overloaded functions
    create function an_overloaded_function()
        returns int language sql stable
    as $$ select 1; $$;

    create function an_overloaded_function(a int)
        returns int language sql stable
    as $$ select 2; $$;

    create function an_overloaded_function(a text)
        returns int language sql stable
    as $$ select 2; $$;

    select jsonb_pretty(graphql.resolve($$
        query {
            anOverloadedFunction
        }
    $$));

    select jsonb_pretty(graphql.resolve($$
        query {
            anOverloadedFunction (a: 1)
        }
    $$));

    select jsonb_pretty(graphql.resolve($$
        query {
            anOverloadedFunction (a: "some text")
        }
    $$));

    -- functions without arg names
    create function no_arg_name(int)
        returns int language sql immutable
    as $$ select 42; $$;

    select jsonb_pretty(graphql.resolve($$
        query {
            noArgName
        }
    $$));

    -- variadic functions
    create function variadic_func(variadic int[])
        returns int language sql immutable
    as $$ select 42; $$;

    select jsonb_pretty(graphql.resolve($$
        query {
            variadicFunc
        }
    $$));

    -- functions returning void
    create function void_returning_func(variadic int[])
        returns void language sql immutable
    as $$ $$;

    select jsonb_pretty(graphql.resolve($$
        query {
            voidReturningFunc
        }
    $$));

    -- functions with a default value
    create function func_with_a_default_int(a int default 42)
        returns int language sql immutable
    as $$ select a; $$;

    select jsonb_pretty(graphql.resolve($$
        query {
            funcWithADefaultInt
        }
    $$));

    create function func_with_a_default_null_text(a text default null)
        returns text language sql immutable
    as $$ select a; $$;

    select jsonb_pretty(graphql.resolve($$
        query {
            funcWithADefaultNullText
        }
    $$));
    
    select jsonb_pretty(graphql.resolve($$
    query IntrospectionQuery {
        __schema {
            queryType {
                fields {
                    name
                    description
                    type {
                        kind
                    }
                    args {
                        name
                        type {
                            name
                        }
                    }
                }
            }
        }
    } $$));
rollback;
