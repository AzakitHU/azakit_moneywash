LANGUAGE = 'en'
FrameworkType = "ESX" -- or "QBCore" (and fxmanifest.lua)
InteractionType = "ox_target" -- Options: "ox_target" or "qb-target" or "3dtext"

Webhook = ""

POLICE_REQ = 1  -- Minimum police required to start
POLICE_JOB = "police"  -- Police Job

ITEM = "black_money"  -- Moneywash black money start check.
TICKETITEM_REQ = true -- If true, you need an extra ticket item
TICKETITEM = "infoticket" -- Ticket item
TICKETITEM_AMOUNT = 1 -- The number of tickets remove
ITEM_AMOUNT = 5000  -- Amount of black money required start / no black money check ITEM_AMOUNT = 0 

START_NPC = {   -- Start Ped
    ped = {
        model = "s_m_m_highsec_01",
        coords = vector3(-1269.8563, -1116.5210, 6.2594),
        heading = 315.9080
    }
}

Duration = 10000 -- Knock Duration. 60000 = 60 seconds
WashDuration =  60000 --  Moneywash time. 60000 = 60 seconds
Cooldowntime =  3600000 -- Cooldown time. 60000 = 60 seconds
WashAreaRadius = 50.0  -- Distance the player cannot leave during the wash

License = true -- Use license items (moneywashlicense, moneywashlicense2, moneywashlicense3) The license is good for any occasion.
Tickets = true -- Use ticket items (moneywashticket, moneywashticket2, moneywashticket3) The ticket is valid for one session.

Tax = 0.30 -- DEFAULT (NOT TICKET / NO LICENSE) Amount taxed during moneywashing. e.g.: 0.30 = 30%
Tax2 = 0.20 -- Amount taxed during moneywashing. e.g.: 0.20 = 20%
Tax3 = 0.10 -- Amount taxed during moneywashing. e.g.: 0.10 = 10%

blipscale = 1.0  -- Blip
blipcolour = 46
blipsprite = 207

Delilocations = {  -- Locations
    {x = 2618.2625,  y = 3275.3318,  z = 55.7382},
    {x = 471.2311,  y = 2607.4612,   z = 44.4775},
    {x = -1127.7528,  y = 2707.9895,  z = 18.8004},
    {x = -252.2210,  y = 6235.0684,  z = 31.4892},
    {x = 1726.0428,  y = 4765.5244,   z = 41.9415},
	{x = 1429.6482,   y = 4377.5586,   z = 44.5993},
	{x = 509.0042,   y = 3099.7554,  z = 41.3079},
	{x = 1514.7108,   y = 3784.7751,   z = 34.4681},
	{x = 712.3112,  y = 2532.7788,   z =  73.5033},
	{x = 3310.7615,  y = 5176.4604,   z = 19.6146},
}
