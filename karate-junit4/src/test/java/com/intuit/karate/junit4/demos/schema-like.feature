Feature: json-schema like validation

Scenario: but simpler and more powerful

* def response = read('odds.json')

* def oddSchema = { price: '#string', status: '#? _ < 3', ck: '##number', name: '#regex[0-9X]' }
* def isValidTime = read('time-validator.js')

Then match response ==
"""
{ 
  id: '#regex[0-9]+',
  count: '#number',
  odd: '#(oddSchema)',
  data: { 
    countryId: '#number', 
    countryName: '#string', 
    leagueName: '##string', 
    status: '#number? _ >= 0', 
    sportName: '#string',
    time: '#? isValidTime(_)'
  },
  odds: '#[] oddSchema'  
}
"""
# other examples

# should be an array
* match $.odds == '#[]'

# should be an array of size 4
* match $.odds == '#[4]'

# optionally present (or null) and should be an array of size greater than zero
* match $.odds == '##[_ > 0]'

# should be an array of size equal to $.count
* match $.odds == '#[$.count]'

# use a predicate function to validate each array element
* def isValidOdd = function(o){ return o.name.length == 1 }
* match $.odds == '#[]? isValidOdd(_)'

# for simple arrays, types can be 'in-line'
* def foo = ['bar', 'baz']

# should be an array
* match foo == '#[]'

# should be an array of size 2
* match foo == '#[2]'

# should be an array of strings with size 2
* match foo == '#[2] #string'

# each item of the array should be of length 3
* match foo == '#[]? _.length == 3'

# should be an array of strings each of length 3
* match foo == '#[] #string? _.length == 3'

# should be null or an array of strings
* match foo == '##[] #string'

# contains
* def foo = [{ a: 1, b: 2 }, { a: 3, b: 4 }]

* def exact = { a: '#number', b: '#number' }
* def partial = { a: '#number' }
* def nope = { c: '#number' }

* def reversed = [{ a: 3, b: 4 }, { a: 1, b: 2 }]
* def first = { a: 1, b: 2 }
* def others = [{ a: 6, b: 7 }, { a: 8, b: 9 }]

* match foo[0] == exact
* match foo[0] == '#(exact)'

* match foo[0] contains partial
* match foo[0] == '#(^partial)'

* match foo[0] !contains nope
* match foo[0] == '#(!^nope)'

* match each foo == exact
* match foo == '#[] exact'

* match each foo contains partial
* match foo == '#[] ^partial'

* match each foo !contains nope
* match foo == '#[] !^nope'

* match foo contains only reversed
* match foo == '#(^^reversed)'

* match foo contains first
* match foo == '#(^first)'

* match foo !contains others
* match foo == '#(!^others)'

* assert foo.length == 2
* match foo == '#[2]'

Scenario: pretty print json
* def json = read('odds.json')
* print 'pretty print:\n' + karate.pretty(json)

Scenario: more pretty print
* def myJson = { foo: 'bar', baz: [1, 2, 3]}
* print 'pretty print:\n' + karate.pretty(myJson)
