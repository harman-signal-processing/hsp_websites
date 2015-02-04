jQuery ($) ->

  calculatePower = (form) ->
    pin  = parseInt($(form.pin).val(), 10)  || 0
    pout = parseInt($(form.pout).val(), 10) || 0
    pdB  = parseInt($(form.pdB).val(), 10)  || 0
    mult = parseInt($(form.mult).val(), 10) || 10

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
