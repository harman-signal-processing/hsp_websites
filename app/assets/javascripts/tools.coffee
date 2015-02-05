jQuery ($) ->

  # Processes both db Power and db Voltage forms
  calculatePower = (form) ->
    pin  = parseFloat($(form.pin).val())  || 0
    pout = parseFloat($(form.pout).val()) || 0
    pdB  = parseFloat($(form.pdB).val())  || 0
    mult = parseFloat($(form.mult).val()) || 10

    if pout != 0 and pdB != 0
      pin = pout / ( Math.pow(10, (pdB / 10)) )

    if pin != 0 and pdB != 0
      pout = pin * ( Math.pow(10, (pdB / 10)) )

    if pin != 0 and pout != 0
      pdB = mult * (0.43429 * Math.log(pout / pin))

    $(form.pin).val(pin.toFixed(1))
    $(form.pout).val(pout.toFixed(1))
    $(form.pdB).val(pdB.toFixed(1))
    false

  $("form.power_calc").submit -> calculatePower(@)

  # Processes the "Amplifier Power Required" form
  $("form#amp_power_required").submit ->
    d2 = parseFloat($(@d2).val()) || 0
    s1 = parseFloat($(@lsens).val()) || 0
    s2 = parseFloat($(@lreq).val()) || 0
    h1 = parseFloat($(@hr).val()) || 0
    w = parseFloat($(@w).val()) || 0

    y = s2 - s1 + (20*(0.43429 * Math.log(d2 / 1)))
    w = Math.pow(10, ((y + h1) / 10))

    $(@w).val( Math.round(w*1) / 1 )
    false

  # Process the inverse square law form
  $("form#inverse_square_law").submit ->
    d1 = parseFloat($(@distance1).val()) || 0
    d2 = parseFloat($(@distance2).val()) || 0
    s1 = parseFloat($(@sound1).val()) || 0

    y = 20 * (0.43429 * Math.log(d1 / d2))
    $(@sound2).val( Math.round((y + s1) * 10) / 10 )
    false

  # Process the line loss form
  $("form#line_loss").submit ->
    p1 = parseFloat($(@prated).val()) || 0
    p2 = parseFloat($(@ploss).val()) || 0
    v = parseFloat($(@vline).val()) || 0
    r = parseFloat($(@r1).val()) || 0
    l = parseFloat($(@r2).val()) || 0

    z = (r / 1000) * l
    y = 2 * z + ((Math.pow(v,2)) / p1)
    p2 = 10 * (0.43429 * Math.log(1 - (2 * z / y) ))
    $(@ploss).val( (Math.round( p2 * 100)) / 100)
    false

  # Process ohm's/watt's laws form
  $("form#ohms_watts_law").submit ->
    volts = parseFloat($(@x).val()) || 1.2345678
    amps =  parseFloat($(@i).val()) || 0
    ohms =  parseFloat($(@r).val()) || 0
    watts = parseFloat($(@w).val()) || 0

    if volts > 0 && ohms > 0
      amps = volts/ohms
      watts = volts*amps

    if volts > 0 && amps > 0
      ohms = volts/amps
      watts = volts*amps

    if volts > 0 && watts > 0
      amps = watts/volts
      ohms = volts/amps

    if ohms > 0 && amps > 0
      volts = amps*ohms
      watts = amps*amps*ohms

    if amps > 0 && watts > 0
      volts = watts/amps
      ohms = volts/amps

    if ohms > 0 && watts > 0
      amps = Math.sqrt((watts/ohms),2)
      volts = amps*ohms

    $(@p).val( watts.toFixed(1) )
    $(@r).val( ohms.toFixed(1) )
    $(@i).val( amps.toFixed(1) )
    $(@x).val( volts.toFixed(1) )
    false

  # Process the constant voltage form
  $("form#constant_voltage").submit ->
    vnew   = parseFloat($(@vnew).val()) || 0
    vrated = parseFloat($(@vrated).val()) || 0
    prated = parseFloat($(@prated).val()) || 0

    if vrated > 0
      bcolor = $(@vnew).css("border-color")
      $(@vrated).css( "border-color": bcolor)
      $(@pactual).val( (((vnew*vnew)/(vrated*vrated)) * prated).toFixed(1) )
    else
      $(@vrated).css( "border-color": "red" )
    false

