const { EmbedBuilder } = require('discord.js');
const resourcePath = global.GetResourcePath ? global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname;
const settingsjson = require(resourcePath + '/settings.js');

module.exports = {
    name: 'changeid',
    description: 'Change a user ID.',
    options: [
        {
            name: "current_user_id",
            description: "Current User ID",
            type: 4,
            required: true,
        },
        {
            name: "new_user_id",
            description: "New User ID",
            type: 4,
            required: true,
        },
        {
            name: "purge_new_id",
            description: "Purge ID",
            type: 5,
            required: false,
        },
    ],
    perm: 10,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        const fivemexports = client.fivemexports;
        const newId = interaction.options.getInteger('new_user_id');
        const oldId = interaction.options.getInteger('current_user_id');
        const purgeNewId = interaction.options.getBoolean('purge_new_id');

        const maxCount = await checkMaxCount(fivemexports);
        if (newId > maxCount){
            message.reply(`You cannot set a user to an ID above the maximum user count`);
            return;
        }
        const playerExists = await checkPlayerExists(fivemexports, oldId);
        if (!playerExists) {
            message.reply(`No player found with ID ${oldId}.`);
            return;
        }
    
        const newIdExists = await checkPlayerExists(fivemexports, newId);
        if (newIdExists) { 
            if (purgeNewId == "true") {
                const statusMessage = await message.channel.send({ embed: createEmbed('Purging ID', '🟨 Starting ID purge process') });
                try {
                    await purgeData(fivemexports, newId, statusMessage)
                    message.channel.send({ embed: createEmbed('Purging ID', `✅ ID purge completed successfully \n**Purged ID**: ${newId}`, embedColors.success) });
                    console.log(`ID purge of ${newId} completed.`)
                } catch (error) {
                    message.channel.send({ embed: createEmbed('Purging ID', `❌ An error occurred: ${error.message}`, embedColors.error) });
                }
            } else {
                message.reply('Please enter `true` after the `idswap` command in order to purge the already existing user');
                return;
            }
        } else {
            fivemexports.corrupt.getConnected([parseInt(oldId)], function(connected) {
                if (connected == "connected"){
                    fivemexports.corrupt.kickUser([parseInt(oldId), "[CORRUPT]: ID Swap in progress\nPlease wait at least 5 minutes or until you receive a discord message from CORRUPT."])
                } 
            })
            const statusMessage = await message.channel.send({ embed: createEmbed('Swapping IDs', '🟨 Starting ID swap process') });
            try {
                await updateDatabaseTables(fivemexports, oldId, newId, statusMessage);
                message.channel.send({ embed: createEmbed('Swapping IDs', `✅ ID swap completed successfully \n**Old ID**: ${oldId}\n**New Id**: ${newId}`, embedColors.success) });
                const result = await fivemexports.corrupt.executeSync(`SELECT * FROM corrupt_verification WHERE user_id = ?`, [newId]);
                let discordid = result[0].discord_id
                let discord_guild = client.guilds.get(settingsjson.settings.GuildID);
                let discord_member = discord_guild.members.get(discordid);
                try { 
                    discord_member.send(`Your ID swap has completed successfully. Your ID has changed from **${oldId}** to **${newId}**`) 
                    console.log(`ID swap from ${oldId} to ${newId} completed.`)
                } catch (error) {}
    
            } catch (error) {
                message.channel.send({ embed: createEmbed('Swapping IDs', `❌ An error occurred: ${error.message}`, embedColors.error) });
            }
        }
    }
};

const embedColors = {
    progress: 16761035,
    error: 16711680,
    success: settingsjson.settings.botColour
};

const tables = [
    { name: 'corrupt_anticheat', field: 'user_id' },
    { name: 'corrupt_bans_offenses', field: 'UserID' },
    { name: 'corrupt_casino_chips', field: 'user_id' },
    { name: 'corrupt_compensation', field: 'user_id' },
    { name: 'corrupt_custom_garages', field: 'user_id' },
    { name: 'corrupt_daily_rewards', field: 'user_id' },
    { name: 'corrupt_dvsa', field: 'user_id' },
    { name: 'corrupt_nhs_hours', field: 'user_id' },
    { name: 'corrupt_owned_plates', field: 'user_id' },
    { name: 'corrupt_police_hours', field: 'user_id' },
    { name: 'corrupt_prison', field: 'user_id' },
    { name: 'corrupt_quests', field: 'user_id' },
    { name: 'corrupt_staff_tickets', field: 'user_id' },
    { name: 'corrupt_stats_data', field: 'user_id' },
    { name: 'corrupt_store_data', field: 'user_id' },
    { name: 'corrupt_subscriptions', field: 'user_id' },
    { name: 'corrupt_users', field: 'id' },
    { name: 'corrupt_user_data', field: 'user_id' },
    { name: 'corrupt_user_homes', field: 'user_id' },
    { name: 'corrupt_user_identities', field: 'user_id' },
    { name: 'corrupt_user_ids', field: 'user_id' },
    { name: 'corrupt_user_info', field: 'user_id' },
    { name: 'corrupt_user_moneys', field: 'user_id' },
    { name: 'corrupt_user_notes', field: 'user_id' },
    { name: 'corrupt_user_tokens', field: 'user_id' },
    { name: 'corrupt_user_vehicles', field: 'user_id' },
    { name: 'corrupt_user_vehicles', field: 'rentedid' },
    { name: 'corrupt_vehicle_mods', field: 'user_id' },
    { name: 'corrupt_vehicle_stancer', field: 'user_id' },
    { name: 'corrupt_verification', field: 'user_id' },
    { name: 'corrupt_warnings', field: 'user_id' },
    { name: 'corrupt_weapon_codes', field: 'user_id' },
    { name: 'corrupt_weapon_whitelists', field: 'user_id' },
];

async function updateDatabaseTables(fivemexports, oldId, newId, statusMessage) {
    let statusDescription = '';
    let exports = fivemexports
    fivemexports.corrupt.execute(`SELECT * FROM corrupt_srv_data WHERE dkey LIKE "%|${oldId}%"`, [], (result) => {
        if (result.length > 0) {
            for (i = 0; i < result.length; i++) { 
                var parts = result[i].dkey.split('|');
                if (parts[1] == oldId) {
                    let new_dkey = result[i].dkey.replace('|'+parts[1], '|'+newId)
                    let newval = fivemexports.corrupt.executeSync(`UPDATE corrupt_srv_data SET dkey = ? WHERE dkey = ?`, [new_dkey, result[i].dkey]);
                }
            }
        }
        statusDescription += `✅ Updated corrupt_srv_data [dkey]\n`;
    });

    for (const [index, table] of tables.entries()) {
        statement = `UPDATE ${table.name} SET ${table.field} = ? WHERE ${table.field} = ?`;
        variables = [newId, oldId];
        const result = await fivemexports.corrupt.executeSync(statement,variables);
        if (result.affectedRows > 0) {
            statusDescription += `✅ Updated ${table.name} [${table.field}]\n`;
        } else {
            statusDescription += `❌ No data to update in ${table.name}\n`;
        }

        await statusMessage.edit({ embed: createEmbed(`Swapping IDs (${index}/${tables.length})`, statusDescription.trim(), embedColors.progress) });
    }

    const weaponWhitelists = await fivemexports.corrupt.executeSync(
        `SELECT weapon_info FROM corrupt_weapon_whitelists WHERE user_id = ?`,
        [newId]
    );

    if (weaponWhitelists.length > 0) {
        let gunstores = JSON.parse(weaponWhitelists[0].weapon_info);
        if (gunstores.length > 0) {
            let updatedWeaponInfo = {};
            for (let key in gunstores) {
                updatedWeaponInfo[key] = {};
                for (let subKey in gunstores[key]) {
                    updatedWeaponInfo[key][subKey] = [...gunstores[key][subKey]]; // Copy the array to avoid modifying the original
                    if (updatedWeaponInfo[key][subKey].length >= 6) { // Ensure there's a 6th element in the array
                        updatedWeaponInfo[key][subKey][5] = parseInt(newId) /// Update the 6th item
                    }
                }
            }
            await fivemexports.corrupt.executeSync(
                `UPDATE corrupt_weapon_whitelists SET weapon_info = ? WHERE user_id = ?`,
                [JSON.stringify(updatedWeaponInfo), newId]
            );
            statusDescription += '✅ Updated weapon whitelists \n';
        } else {
            statusDescription += `❌ No weapon whitelists to update\n`;
        }
    } 
    await statusMessage.edit({ embed: createEmbed('Swapping IDs', statusDescription.trim(), embedColors.progress) });
}

function createEmbed(title, description, color = embedColors.progress) {
    return {
        color,
        title,
        description,
        timestamp: new Date(),
        footer: { text: "CORRUPT" }
    };
}

async function checkPlayerExists(fivemexports, id) {
    const result = await fivemexports.corrupt.executeSync(`SELECT * FROM corrupt_users WHERE id = ?`, [id]);
    return result.length > 0;
}

async function checkMaxCount(fivemexports) {
    const result = await fivemexports.corrupt.executeSync(`SELECT COUNT(id) FROM corrupt_users`, []);
    return result[0].id
}

async function purgeData(fivemexports, newId, statusMessage) {
    let statusDescription = '';
    for (const [index, table] of tables.entries()) {
        statement = `DELETE FROM ${table.name} WHERE ${table.field} = ?`;
        variables = [newId];
        const result = await fivemexports.corrupt.executeSync(
            statement,
            variables
        );
        if (result.affectedRows > 0) {
            statusDescription += `✅ Deleted ${table.name} [${table.field}]\n`;
        } else {
            statusDescription += `❌ No data to delete in ${table.name}\n`;
        }

        await statusMessage.edit({ embed: createEmbed(`Purging ID (${index}/${tables.length})`, statusDescription.trim(), embedColors.progress) });
    }
    await statusMessage.edit({ embed: createEmbed('Purging ID', statusDescription.trim(), embedColors.progress) });
}