local webhooks = {
    -- general
    ['join'] = 'https://discord.com/api/webhooks/1269921576875196496/q26xGQufs4SQaV2DoTJJ71BA7uvSvzN4rvI42KG-bxco-vzHKiy62nZTRiAYHoe8E3di',
    ['leave'] = 'https://discord.com/api/webhooks/1269921824439799948/AmhQFsGX-DrD8X3yeUDYrEPlpTqN4yt_KNsh2gR3eMIZN6_cNykSyHFvoa6LZ57nBDsn',
    ['steam'] = 'https://discord.com/api/webhooks/1269922301969829970/uIuPCflwZJ16f4Typj9yg1TnmossDlJ92VjQd0h_rTjOE23iyXslyvxr5nRfNXyjkHXH',
    -- civ
    ['give-cash'] = 'https://discord.com/api/webhooks/1269922441497411596/honjn8bZPb2qCFBWufyERfCiWCptAWMwANSYRw3mLIVKDjasnmxWJ8TZ5RPchSVEwUie',
    ['bank-transfer'] = 'https://discord.com/api/webhooks/1269922586372997192/86cBMg-EoXSNFkaollzWbG4KpNg22Og6Pfp_KdyZtFGGzdtu0Xc-Wb2zesMvx5sw7nFo',
    ['search-player'] = 'https://discord.com/api/webhooks/1269922822441144354/ONBo4Ph3djeYqlBQFXgK0WYWROmSRabpiaVF81W2rb0L6KufIXlN8WgREtnO95Zfbpdg',
    ['gang'] = 'https://discord.com/api/webhooks/1269923135239622677/A2Rx8mpkftx9bqlvVOtPsXtpbCyg4fs-gEeL_1d8iZnKGlhaQH88uybuQJgVqZBVGmKj',
    -- chat
    ['ooc'] = 'https://discord.com/api/webhooks/1270461384672411749/Zzf9KSE9jA71flF9R-EgwW6quefEUPM3X-C_vMreIo19SHeDq8ssLzoD0HWb49a8uM1v', --
    ['twitter'] = 'https://discord.com/api/webhooks/1270461521238949940/nnPO1M2RgE908EJm1cnMWicivfXFIJjleSR6qTe7Zy9dXTpeKOkh0T3U8HGAm9v80mnG',--
    ['staff'] = 'https://discord.com/api/webhooks/1270461644916391976/ol-YH65_Tj5elvB9H_85LV2SwYedyY6SIrNTXplVFKVh2fdo1iwJSBP3XU9MtHK6eGoo',--
    ['gang'] = 'https://discord.com/api/webhooks/1270461756099268618/K0bqMJMLQwVoHqFPMmuT2vz1y2FUNxr7LJTtEauoORdbc1WuHL_-K_pkikQXMapqa9nZ',--
    ['anon'] = 'https://discord.com/api/webhooks/1270461910202187928/XeMuh8YzQ31h4yUiZ8NbP0LIkJFr7QzlmtS4_0nuOuj29BiX-39ttthigW0Y-bZJod0o',--
    ['announce'] = 'https://discord.com/api/webhooks/1270462001432231956/iHc_w98QoBC0EQSGkGBjcJ4AZfWeB4NhVHlwl5b7aVr6xw24lZBicV_MDPgMRbrLtUIo',--
    -- admin menu
    ['kick-player'] = 'https://discord.com/api/webhooks/1270462287601467412/dU8o0IWAP3GmfJ7IvixEoSn1lLpiqaD7UyFMIkOoR_Rq1CfMaQcXdBvQe0ejEG98FJBT', --
    ['ban-player'] = 'https://discord.com/api/webhooks/1270462361454645259/VJ2hM01f1oXAi7lFYx5iymrPe96ZwUMXhWE5JssfcXvvtdTOI85OHHTtOHRLogb1wUWd', --
    ['spectate'] = 'https://discord.com/api/webhooks/1270465565865152552/zMoGnHGFrbViTHFrSu-pcCQW6gk32oCFsPegEoM_EJl7AHO-bF9IZ7czHj1JpcxJUMAU', --
    ['revive'] = 'https://discord.com/api/webhooks/1270465648698462309/2IrIPjRrzdb7eKkVDk9reFUvVtrIM0ISTSaaxgQReTFxv3gBrvoNEjGIq9rUno5_JsFz', --
    ['tp-player-to-me'] = 'https://discord.com/api/webhooks/1270465716948303944/vakulcnqt6uFRNnBkAnYPTWADPT9qP7u-kY-W2rtCxMX9U-NIIo-2e4KYXxhz9zvBQYt', --
    ['tp-to-player'] = 'https://discord.com/api/webhooks/1270465855276187772/wHfJwDQTAN1fjLTVdCrsKeLkum2WLBj1BlVgMs2GI8EhkKC9_CrTUQkDtpCadr5SCNFi', --
    ['tp-to-admin-zone'] = 'https://discord.com/api/webhooks/1275133454480052295/tFC1d9jiQDXv8QBVi9qaw7_zHmqJEdehYpSH2Q11dY2sSR_GV9su3i9Ry_TJkJzcYgGa',--
    ['tp-back-from-admin-zone'] = 'https://discord.com/api/webhooks/1199719975691239424/jlLSBcyyzjuhZUz4P1ZMUoOWb9IHs1xvWAW9Iw60O-cvD8dYPped92GtAQR2DwxKCkeH', --
    ['tp-to-legion'] = 'https://discord.com/api/webhooks/1275133772089524319/vUUKBkga0ELmTsLE2inCAdlg2_gkT8yD44Y5HVNN--0iT7xMetFZSSgjC2b8rEUwz_eh',--
    ['freeze'] = 'https://discord.com/api/webhooks/1275133918521331852/CiZ_ccMzjtdQ0gVxRtzFPqZuF7KX8YXpqLhlQowi8NxHnBhGZSCG8jBbG9JkBg_EtmsB',--
    ['slap'] = 'https://discord.com/api/webhooks/1275133984451592312/AcOPy_xTJ00lTfvTdzV7503M7jGdfKh-QH_kQ_iOIiY6U72yWlo0tM-oEM8QghJfDZwG',--
    ['force-clock-off'] = 'https://discord.com/api/webhooks/1275134091670589563/P8PMGLj6m2M4NVOx51hgHg9gP23X3NxNlmHdhzpqOKVSq2as527Rt7DR08PuyPi-Ov3y',--
    ['screenshot'] = 'https://discord.com/api/webhooks/1275134214617956424/6ahRSae22lyNVKlamM7lw0e_4KwJf42h1ymKUQoadxU2H6lxlZ7T2tyE_w12azvu602f',--
    ['video'] = 'https://discord.com/api/webhooks/1275134336429064232/ybOOvGr_bMInaJU3jKjL9jYE9szp7UEVP1695A2GPXCv4du4JeQW1pY3CdeZ1O2fadJg',--
    ['group'] = 'https://discord.com/api/webhooks/1275134409158299649/-foYbyOGq8FhKgj1vR2rBmLM6TcPCp0OZSdipUc1VjF8YCKepCggbRCvwYPHhBHSKLLU',--
    ['unban-player'] = 'https://discord.com/api/webhooks/1275134518151352425/KeoJVAig0CiMRpMiqtDhw7fMupCImcXsW5MBVgFRDl3HLQIvsRnnbU6ovrkouT3ucuD-',--
    ['remove-warning'] = 'https://discord.com/api/webhooks/1275134806791028789/gtrRhFHfDevTfyF8YWqLwAWSv5zbXqch1As_jFK9tbiSkxnjbEsjYK4FhwxGARhvUcv1',--
    ['add-car'] = 'https://discord.com/api/webhooks/1275134907999322236/tRYWA0c-k08cI2znPcD6V_7uu-NIJaNrsWpNJEbyp1jr3OyDuvQ4duBt8lfUh2YTbQPh',--
    ['manage-balance'] = 'https://discord.com/api/webhooks/1275135002769756253/eRrcJcLBuT7ctoJ6ZzvyXBg-zZZepLV104b_gs_72izoVRRIaoHbvQu0uoleRDCi9-rj',--
    ['ticket-logs'] = 'https://discord.com/api/webhooks/1275135116112560229/VAOfr29l4Vqz1lw-lKVeHezQIzilC2PkrYuiPCEu-h1sU_YogPHkrBSl9HWGPkVYbicQ',--
    ['com-pot'] = 'https://discord.com/api/webhooks/1275135201550274561/8dk2eSCZTOOyidBb0Tgvi-jIQOQLcRv8e7yoNAPORo39lwU1dHHhs4_yeWFsrGHeO_oy',--
    ['staffdm'] = 'https://discord.com/api/webhooks/1275135289299439748/kLEtbk3udm_mCNwhOEuNXqLC50aIft5fRU6p7o42eFTpizy1ZYlzIgcsttn4vkQ_zxaB',--
    -- vehicles
    ['crush-vehicle'] = 'https://discord.com/api/webhooks/1271068165270536233/-nbuXGSXTlfFRoZE2znldUVKW2vOocptN30mf8G_GvTVY1MEjU-R5t9-Ybr3L2dkmsYz', --
    ['rent-vehicle'] = 'https://discord.com/api/webhooks/1271068047423045682/3-PwuZzW7cuHw9upvujBTgAuLbrn6NObmcVS-hUhW0QiTXzu6jC30Giv6yWb-Asr7brC',
    ['sell-vehicle'] = 'https://discord.com/api/webhooks/1271067813485871174/UJSaX1vqSwXRu_pGG0A3-7ti_loxFgbO-ZvFNXhY5NENI6KkmG2CZzKOoRuQMgiij3GS', 
    ['spawn-vehicle'] = 'https://discord.com/api/webhooks/1271067713590267904/NvQuPdd8BKhEgGAnGBzBRqzrfRh-Hb71zEGcrbocVcEydZbCO4BbFX6SreW4aMSy9xvJ', --

    -- mpd
    ['pd-clock'] = 'https://discord.com/api/webhooks/1272128482595311728/5b_TiciumSY-y0yNIxP__UKbTwg4eH9pxvE578ppc4WFrXUfHNtANV8EEyZertypUUQn', --
    ['pd-afk'] = 'https://discord.com/api/webhooks/1272130637607993439/3bsavQUPjxkSJwsxpL4w6vlGSyD18NNWtXB8IqqNTj1F6GlNIMpZTl7bcFk1Wf9VUnpW',
    ['pd-armoury'] = 'https://discord.com/api/webhooks/1272128375762194442/Prfali51iy21e2IqkbLe_MUn_JAEge6e-y1XjttUVsInxq4yga-m0sz11IPvbBtdkDr8', --
    ['fine-player'] = 'https://discord.com/api/webhooks/1270707503482671144/oPCoB_zKwd9ozzf0FVgUlPWFL0EXHejP2BBkLOJYSQeOVZbLLNh2QEoNvs9xQ1x62xh7',
    ['jail-player'] = 'https://discord.com/api/webhooks/1272129409976893440/S3iggYCmNrcpw86Lu-GPwYFmlguDe4atbJ57mZXWTilfNLgvYy977UfJniryXd72UPWH', --
    ['pd-panic'] = 'https://discord.com/api/webhooks/1272128590074613875/fzCoeEe8jafu94SH__VXXIQKl9jqoqRGqX8UyD8RaXrEWRh71ImXvrYQ3c48lqExTOGF', --
    ['seize-boot'] = 'https://discord.com/api/webhooks/1272130569831976992/0weU8iSzxOJhoizthI_5lpC5gBqrRdXtqWliUQthJgLXGUG2QvPjJEOFEbsQ1ndRiZZr',
    ['impound'] = 'https://discord.com/api/webhooks/1272130477976977408/E7Lh8UOZzjaTWVpt2NRJFtbY2REXB9asb_NGmaYftSOFTu7Yuo3NlX8oFzfh99IAIYVJ',
    ['police-k9'] = 'https://discord.com/api/webhooks/1270708141100761100/ebIB_Zztjd-fBCYn9oHGBcvTqGIJI0b1FSNeEclm9c4qrZYv4TLGhJyEnJt7qa_F_5-5', --
    ['speed-gun'] = 'https://discord.com/api/webhooks/1272128770869952535/OrEkqMcNwckoC-oTGej00K7Zd6Nja0LHYj27-n5m92gIzZD9q6LR5cGJ7KKx1D9jHdUU', --
    ['spawn-menu'] = 'https://discord.com/api/webhooks/1272129347599204486/oaYWjhG6edJRqhIymHKvPZ5UexFD4WCo0URg4VkEzz45mNx75CPcYGqGAfUiSdMWrdbh', --
    ['speed-gun'] = 'https://discord.com/api/webhooks/1272129561827741746/noSXX9U5j7jqeNoFNmWwV5wufhMfpM_P97rIfWcoPAAsdL6e0ubBJ9fc9P0_uDBv4knK', --

    -- nhs
    ['nhs-clock'] = 'addhere',
    ['nhs-panic'] = 'addhere',
    ['nhs-afk'] = 'addhere',
    ['cpr'] = 'addhere',
    
    --hmp
    ['hmp-clock'] = 'addhere',
    ['hmp-afk'] = 'addhere',
    ['nhs-panic'] = 'addhere',

    -- licenses
    ['purchases'] = 'https://discord.com/api/webhooks/1271067067067400246/rN53pSt5vKYIUe6mfuL5Yn-3lRhSbk2MN0wiht-NJNh4cRBaDm5Alwxy04aomd0XjZfX', --

    -- casino
    ['blackjack-bet'] = 'https://discord.com/api/webhooks/1271068916395020318/eg9BXq_1A73hPwUWwlfbZhczsAwVYqkAe7yBTvYHY5srB3m0FhjTvWHf-NnPC6mvCPH5', --
    ['coinflip-bet'] = 'https://discord.com/api/webhooks/1271069045650751500/wqX5qpJaF8Z4uCQrzN45tfuJwTQ0nrZSaMuzFf89q17mMAVPxoJF34NtRZhDKb7CInz-',
    ['purchase-chips'] = 'https://discord.com/api/webhooks/1271069806866468966/LMwI3jI4xoAXsqX0FhkZmo6wWtmZ5o7ePhgMRpud-Nt_4x0C2jkne11UmG5Fi3i-aaOL',
    ['sell-chips'] = 'https://discord.com/api/webhooks/1271069911933915227/76XeXgrmQr_gvCP2RdIigVERRtYMO9gmRC_GIzGMixov2oD2t6yOjgsZ-154_9MzJYC8',
    ['purchase-highrollers'] = 'https://discord.com/api/webhooks/1271070009485164594/C1rjhdmw_R0grtEYSlq87-5DZDI7aQi_6kjANxiqFYTHt7YVrJ2Ol4R0aI3TgomxejFh', --
    ['slot-outcomes'] = 'https://discord.com/api/webhooks/1291127544107499610/TzTGFHFvsUc7EhcoimqiRNVIAydUh13BTgDUOohh3uJ6IBtt4a6UclKVf8HWP1HFGvY9',

    -- weapon shops
    ['weapon-shops'] = 'https://discord.com/api/webhooks/1271066698392277023/kDvpBdDSPrPZ9gWd9S8Ufd3wqtg7BtSOK291RfeOeANRfPfpBwhYOsec1wgfTYFXRASX', --

    -- anticheat
    ['anticheat'] = 'https://discord.com/api/webhooks/1271066267373277214/0PWz2skyCKZXHbDw8Hxx0RJAVzHA6w44J9D9fbJboXfJCmAxTbmeI47p4q75vvhX7JNq', --
    ['ban-evaders'] = 'https://discord.com/api/webhooks/1271066437313761290/Vuxh_w5gNC8x0AHZL20D-8GvUFhndZIigr8QG1SmbKUVLnKxlFpv8HzwtKEyffkmWUt5',
    ['multi-account'] = 'https://discord.com/api/webhooks/1271066547141738517/wlEAnrrVHr32qGol1KkvanyuXzbOnV3IPAX0pNRfu9IV5CRkQzF-lf1iV7fUUfCK77pg',--

    -- general
    ['banned-player'] = 'https://discord.com/api/webhooks/1271065829101797386/TWprtdcPZsk76xVkMIzwRypHYK_N24znjP5wgKbr7M9a77FSJK1dfrq97DmTo3QTgzZm', --
    ['kill-vids'] = 'https://discord.com/api/webhooks/1291783099792756819/_E7KY7DP8WBX5E3F972T-p_DsQbameJHbHo0Tn4v-7Qm1lK7t0euPK5I6soa4ttXowMj',
    ['kills'] = 'https://discord.com/api/webhooks/1271064921144164396/B1sM2dW90qolQzYDYcSaXuUNSeiuLwnBuB6r1uyg-i5TjqSh8GDX701aR0w9Si_iuNTC',
    ['damage'] = 'https://discord.com/api/webhooks/1271065192939393127/nOlUqRllJqhP1H6zceBsKojULzg5pcrovf6y0p-I1kjQWnEQzg7SoOuZnrFIY4coNGdS',
    ['trigger-bot'] = 'https://discord.com/api/webhooks/1271065305447137412/1UT7EfwYYTIg_nMfSTCGiwCNQUQk6cWJFqI04f963kq-Wc6vWahrjSeHI7bWp4xVwxoI',
    ['headshot'] = 'https://discord.com/api/webhooks/1271065459164188693/qJuWpE1wQNQNUI_5UgXWy-85HugcQvCO3OINrXeJJ6fXCGTWDEFYPuzNrgx3kFokOPTd', --
    -- store
    ['sell-packages'] = 'https://discord.com/api/webhooks/1199721304190877787/AqzvcH-Hl1BbN2qm9r0EJ_CI4HQpT7wCkARZ5L0GK4kIQM8IHaICGa4d9EDMJR5Zz022',
    ['redeem-packages'] = 'https://discord.com/api/webhooks/1199721268774195330/v7nJ9PMCavsn8u5xCQdr3YOegKauKHYDCS06zTL8hN3wPWE1-xOfsoHDZ4AfdQFly_9v',
    ['tebex'] = 'https://discord.com/api/webhooks/1199721425121062982/3va-DdIuF2MD1mepo3TxpbUQeSNtFxw7tyZL2tZVSGxpJqrfEQyYMI1sg_Gv0OfieLVY',
    ['donation'] = 'addhere',
    -- Wipe
    ['storage'] = 'https://discord.com/api/webhooks/1272131412702527529/dCyV7YMHj7K0jRruhkmceGGuMyp-CtfNWaTaM1OXm4kp8bStAChzvKeBLfUCIIMPWTRE', --
    ['new-month'] = 'https://discord.com/api/webhooks/1272131466519777344/T-ooJGXANlfUimYpZQ4LZwoVUt-IbNahTjqamI5G3wY2N2sLi5oTOGrturtdiNARVVNg', --
    -- Error WebHooks
    ['client-error'] = 'https://discord.com/api/webhooks/1211707327170879569/WEKJS2NtaSnmN0DVzgWiOQkY8tMAnqmYQrQ612YY-xmO8Tj4FcE8mjbs0wu-fVp71wHO',
    ['server-error'] = 'https://discord.com/api/webhooks/1211707594100711475/mmcO6K7ojPsD5GF8NTKI55jZrhxSkWXo6AI-TYvycy0_4JvrWVFlVvajpMwTcTlVjwbK0',
    ['new-joiners'] = 'https://discord.com/api/webhooks/1272131585478492214/TWLPxGrHLtkz30Ecn9WrSZLEsuDfoCuKe3LYjPQXNhx0xoi6EkXomDg5JhROyUnuqdRY', --
    ['media-cache'] = 'https://discord.com/api/webhooks/1291772732568109056/Sj7LHOF37_SBjCy5H01YSF-dvmpPg1AVBPaqCH5T1vxhKw60M5c9Tf_vn2AySYhB2KJH',
}

local webhookQueue = {}
Citizen.CreateThread(function()
    while true do
        if next(webhookQueue) then
            for k,v in pairs(webhookQueue) do
                Citizen.Wait(100)
                if webhooks[v.webhook] ~= nil then
                    local embed = {
                        {
                            ["color"] = 0x0078ff,
                            ["title"] = v.name,
                            ["description"] = v.message,
                            ["footer"] = {
                                ["text"] = "CORRUPT - "..v.time,
                                ["icon_url"] = "",
                            }
                    }
                    }
                    if v.image then embed[1].image = {url = v.image} end
                    PerformHttpRequest(webhooks[v.webhook], function(err, text, headers) 
                    end, "POST", json.encode({username = "CORRUPT Logs", avatar_url = 'https://cdn.discordapp.com/attachments/1129927706621005864/1198686465710903416/blue.png?ex=65bfcec3&is=65ad59c3&hm=d6e8eac661fd116a2c80e91946f3bca9cb3a8a7aaf3ae66908e42f6bc679d740', embeds = embed}), { ["Content-Type"] = "application/json" })
                end
                webhookQueue[k] = nil
            end
        end
        Citizen.Wait(0)
    end
end)
local webhookID = 1
function CORRUPT.sendWebhook(webhook, name, message, image)
    webhookID = webhookID + 1
    webhookQueue[webhookID] = {webhook = webhook, name = name, message = message, time = os.date("%c"), image = image}
end

function CORRUPT.getWebhook(webhook)
    if webhooks[webhook] ~= nil then
        return webhooks[webhook]
    end
end