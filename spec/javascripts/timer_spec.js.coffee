describe 'Timer', ->
  it 'creates a new timer', ->
    timer = new Timer()
    expect(timer).toBeDefined()

  it 'calls progress callback every 10ms', ->
    spy = jasmine.createSpy()
    timer = new Timer()
    timer.progress spy
    runs ->
      timer.start()
    waits '11'

    runs ->
      timer.stop()
      expect(spy.callCount).toBe 1
      expect(spy.mostRecentCall.args[0]).toBeGreaterThan(10)
    

