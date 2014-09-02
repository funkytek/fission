Model = require 'ampersand-model'
should = require 'should'
fission = require './fixtures/fissionInstance'

describe '#model', ->
  it 'should produce a model', (done) ->

    m = fission.model
      props:
        firstName: 'string'
        lastName: 'string'

    m.should.be.type 'function'
    m.__super__.save.should.be.type 'function'
    m.__super__.fetch.should.be.type 'function'
    m.__super__.destroy.should.be.type 'function'
    m.__super__.sync.should.be.type 'function'

    inst = new m
      firstName: 'Steve'
      lastName: 'Jobz'

    inst.should.be.instanceOf Model
    inst.firstName.should.equal 'Steve'
    inst.lastName.should.equal 'Jobz'

    inst.url = '/api/'
    inst.on 'change', (data) ->
      inst.save()
      inst.lastName.should.equal 'Nash'

    inst.set lastName: 'Nash'

    done()

  it 'should not contain elements if not defined in model.props', (done) ->

    m = fission.model
      props:
        firstName: 'string'
        lastName: 'string'
    inst = new m
      firstName: 'Larry'
      lastName: 'Page'
      age: '50'
    inst.firstName.should.equal 'Larry'
    inst.lastName.should.equal 'Page'
    should.not.exist inst.age

    done()

  it 'should return an error if error', (done) ->
    m = fission.model
      props:
        firstName: 'string'
        lastName: 'string'
    inst = new m
      firstName: 'Larry'
      lastName: 'Page'
    inst.on 'error', (err) ->
      err.should.not.be.null

    inst.sync = (method, model, options) ->
      options.error()

    inst.save()
    inst.fetch()

    done()
