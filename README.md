# Moneywash with tickets, licenses, tax levels, transport
You can wash money in a location obtained through an informant.
In order to receive the coordinates, the informant performs NPC checks. Do you have the minimu black money for money washing and the information ticket?
If so, you get the address. However, you will still need a moneywash ticket or license at the venue. There are 3-3 different types of moneywash tickets and licenses, and each one charges different taxes during moneywashing. The ticket is valid for one session. The license is good for any occasion.
Everything can be easily changed in the config.lua file.

* Easy configuration
* Checking items
* 3 types Moneywash Ticket
* 3 types Moneywash license
* Three tax levels
* 10 preset addresses
* Cooldown
* Discord Webhook

# Preview
https://www.youtube.com/watch?v=OMqsnhoyeDk

# Install
- Clone or Download the [repository](https://github.com/AzakitHU/azakit_moneywash).
- Add the **azakit_moneywash** to your resources folder.
- Add `ensure azakit_moneywash` to your **server.cfg**.

# OX Inventory Items
	
	['infoticket'] = {
		label = 'Info Ticket',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['moneywashticket'] = {
		label = 'Moneywash Ticket 1',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['moneywashticket2'] = {
		label = 'Moneywash Ticket 2',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['moneywashticket3'] = {
		label = 'Moneywash Ticket 3',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['moneywashlicense'] = {
		label = 'Moneywash License 1',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['moneywashlicense2'] = {
		label = 'Moneywash License 2',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['moneywashlicense3'] = {
		label = 'Moneywash License 3',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

# Requirements
- ESX
- ox_lib
- ox_target

# Documentation
You can find [Discord](https://discord.gg/DmsF6DbCJ9).
