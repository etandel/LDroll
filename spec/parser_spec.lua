local parse = require 'ldroll.parser'.parse


describe('Pattern tests', function()
    it('should parse constants', function()
        local s = '140'
        local tree = {
            [1] = {
                const = '140'
            }
        }
        assert.are.same(tree, parse(s))
    end)

    it('should parse single-digit rolls', function()
        local s = '1d6'
        local tree = {
            [1] = {
                roll = {
                    ndice = '1',
                    dsize =  '6'
                }
            }
        }
        assert.are.same(tree, parse(s))
    end)

    it('should parse multi-digit rolls', function()
        local s = '10d62'
        local tree = {
            [1] = {
                roll = {
                    ndice = '10',
                    dsize =  '62'
                }
            }
        }
        assert.are.same(tree, parse(s))
    end)

    it('should parse operations', function()
        local s = '10d62+2'
        local tree = {
           [1] = {
                roll = {
                    ndice = '10',
                    dsize =  '62'
                }
            },
            [2] = {
                const = '2'
            },
            op = '+',
        }
        assert.are.same(tree, parse(s))
    end)

    it('should parse operations (with spaces)', function()
        local s = ' 10d62 + 2 '
        local tree = {
            [1] = {
                roll = {
                    ndice = '10',
                    dsize =  '62'
                }
            },
            [2] = {
                const = '2'
            },
            op = '+',
        }
        assert.are.same(tree, parse(s))
    end)

    it('should parse parenthised single rolls', function()
        local s = '( 1d6 )'
        local tree = {
            [1] = {
                [1] = {
                    roll = {
                        ndice = '1',
                        dsize = '6'
                    }
                }
            }
        }
        assert.are.same(tree, parse(s))
    end)

    it('should parse parenthised ops', function()
        local s = '( 1d6 + 2 )'
        local tree = {
            [1] = {
                [1] = {
                    roll = {
                        ndice = '1',
                        dsize = '6'
                    }
                },
                [2] = {
                    const = '2'
                },
                op = '+',
            }
        }
        assert.are.same(tree, parse(s))
    end)

    it('should parse nested terms', function()
        local s = '1d6 + (2d6 + 4)'
        local tree = {
            [1] = {
                roll = {
                    ndice = '1',
                    dsize = '6'
                }
            },
            [2] = {
                [1] = {
                    roll = {
                        ndice = '2',
                        dsize = '6'
                    }
                },
                [2] = {
                    const = '4'
                },
                op = '+'
            },
            op = '+',
        }
        assert.are.same(tree, parse(s))
    end)

    it('should parse deeply nested terms', function()
        local s = '(1d6 +1) - (2d6 + (2 + 4d10))'
        local tree = {
            [1] = {
                [1] = {
                    roll = {
                        ndice = '1',
                        dsize = '6'
                    }
                },
                [2] = {
                    const = '1'
                },
                op = '+'
            },
            [2] = {
                [1] = {
                    roll = {
                        ndice = '2',
                        dsize = '6'
                    }
                },
                [2] = {
                    [1] = {
                        const = '2'
                    },
                    [2] = {
                        roll = {
                            ndice = '4',
                            dsize = '10'
                        }
                    },
                    op = '+'
                },
                op = '+'
            },
            op = '-',
        }
        assert.are.same(tree, parse(s))
    end)
end)


describe('Ops parsing tests', function()
    it('should parse whole add', function()
        local s = '1 + 2'
        local tree = {
            [1] = {const = '1'},
            [2] = {const = '2'},
            op = '+',
        }
        assert.are.same(tree, parse(s))
    end)

    it('should parse whole sub', function()
        local s = '1 - 2'
        local tree = {
            [1] = {const = '1'},
            [2] = {const = '2'},
            op = '-',
        }
        assert.are.same(tree, parse(s))
    end)

    it('should parse rollwise add', function()
        local s = '1 .+ 2'
        local tree = {
            [1] = {const = '1'},
            [2] = {const = '2'},
            op = '.+',
        }
        assert.are.same(tree, parse(s))
    end)

    it('should parse rollwise sub', function()
        local s = '1 .- 2'
        local tree = {
            [1] = {const = '1'},
            [2] = {const = '2'},
            op = '.-',
        }
        assert.are.same(tree, parse(s))
    end)
end)


describe('Function parsing tests', function()
    it('should parse empty call', function()
        local s = 'foo()'
        local tree = {{
            func = {
                ident = 'foo',
            }
        }}
        assert.are.same(tree, parse(s))
    end)

    it('should parse one const arg', function()
        local s = 'foo(1)'
        local tree = {{
            func = {
                {const = '1'},
                ident = 'foo',
            }
        }}
        assert.are.same(tree, parse(s))
    end)

    it('should parse const-only args', function()
        local s = 'foo(1 2 3)'
        local tree = {{
            func = {
                {const = '1'},
                {const = '2'},
                {const = '3'},
                ident = 'foo',
            }
        }}
        assert.are.same(tree, parse(s))
    end)

    it('should parse roll-only args', function()
        local s = 'foo(1d4 20d2 10d10)'
        local tree = {{
            func = {
                {roll = {ndice = '1', dsize = '4'}},
                {roll = {ndice = '20', dsize = '2'}},
                {roll = {ndice = '10', dsize = '10'}},
                ident = 'foo',
            }
        }}
        assert.are.same(tree, parse(s))
    end)

    it('should parse mixed args', function()
        local s = 'foo(1d4 20 10d10)'
        local tree = {{
            func = {
                {roll = {ndice = '1', dsize = '4'}},
                {const = '20'},
                {roll = {ndice = '10', dsize = '10'}},
                ident = 'foo',
            }
        }}
        assert.are.same(tree, parse(s))
    end)

    it('should parse nested calls', function()
        local s = 'foo(1d4 bar(20) 10d10)'
        local tree = {{
            func = {
                {roll = {ndice = '1', dsize = '4'}},
                {func = {
                    {const = '20'},
                    ident = 'bar',
                }},
                {roll = {ndice = '10', dsize = '10'}},
                ident = 'foo',
            }
        }}
        assert.are.same(tree, parse(s))
    end)

    it('should parse deeply nested calls', function()
        local s = 'foo(bar(baz(20)))'
        local tree = {{
            func = {
                {func = {
                    {func = {
                        {const = '20'},
                        ident = 'baz',
                    }},
                    ident = 'bar',
                }},
                ident = 'foo',
            }
        }}
        assert.are.same(tree, parse(s))
    end)
end)
