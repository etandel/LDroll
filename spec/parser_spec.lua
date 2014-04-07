local parse = require 'parser'.parse


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
