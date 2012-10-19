define [
  # Application.
  "app"

  # Libraries.
  "underscore"
  "backbone"

  # Modules
  "modules/sura"

  # Vendor data.
  "qurandata"
],

(app, _, Backbone, Sura, VendorData) ->

  # cleanup vendor datafile
  # make all data as Backbone.Model
  Data = {}

  mapping =
    Sura:        {name: 'Suras',   keys: ['start', 'ayas', 'order', 'rukus', 'name', 'tname', 'ename', 'type']}
    Juz:         {name: 'Juzs',    keys: ['sura', 'aya']}
    HizbQuarter: {name: 'Hizbs',   keys: ['sura', 'aya']}
    Manzil:      {name: 'Manzils', keys: ['sura', 'aya']}
    Ruku:        {name: 'Rukus',   keys: ['sura', 'aya']}
    Page:        {name: 'Pages',   keys: ['sura', 'aya']}
    Sajda:       {name: 'Sajdas',  keys: ['sura', 'aya', 'hukm']}

  for infoName, infoVal of mapping
    if infoVal.name == 'Suras'
      # special for Suras
      Data[infoVal.name] = new Sura.Collection
      model = Sura.Model
    else
      # generic for others
      Data[infoVal.name] = new Backbone.Collection
      model = Backbone.Model

    i = 0
    for val in VendorData[infoName]
      data = {}
      data['id'] = i + 1
      for key, j in infoVal.keys
        data[key] = val[j]

      Data[infoVal.name].add new model(data)
      i++

  # Misc.
  Data.Markings =
    Pause: ["\u06D6", "\u06D7", "\u06D8", "\u06D9", "\u06DA", "\u06DB"]
    Vowel: ["\u064B", "\u064C", "\u064D", "\u064E", "\u064F", "\u0650", "\u0651",
            "\u0652", "\u0653", "\u0654", "\u0655", "\u0656", "\u0657", "\u0658",
            "\u0659", "\u065A", "\u065B", "\u065C", "\u065D", "\u065E"]
    Sajda:  "\u06E9"

  app.Data = Data

  Data
