const { EmbedBuilder } = require('discord.js');

module.exports = {
    name: "genwhitelistweapon",
    description: "Generate Weapon Whitelist",
    options: [
        {
            name: "user_id",
            description: "Perm ID",
            type: 4,
            required: true,
        },
        {
            name: "spawn_code",
            description: "Weapon Spawn Code",
            type: 3,
            required: true,
        }
    ],
    perm: 10,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);
        let permid = interaction.options.getInteger('user_id')
        let weapon = interaction.options.getString('spawn_code')
        let weapon_code = Math.floor(Math.random() * (999999 - 100000 + 1)) + 100000;
        fivemexports.corrupt.execute("INSERT IGNORE INTO corrupt_weapon_codes SET user_id = ?, spawncode = ?, weapon_code = ?", [permid, weapon, weapon_code], (result) => {
            if (result) {
                const embed = new EmbedBuilder()
                .setTitle("Added Weapon")
                .setDescription("Perm ID: **" + permid + "**\nSpawn Code: **" + weapon + "**\nWeapon Code: **" + weapon_code + "**")
                .setColor(0x0078FF)
                .setTimestamp(new Date())
                interaction.reply({ embeds: [embed], ephemeral: true });
            } else {
                const embed = new EmbedBuilder()
                .setTitle("Failed to add Weapon")
                .setDescription("Perm ID **" + permid + "** already owns **" + weapon + "**")
                .setColor(0xFF0000)
                .setTimestamp(new Date())
                interaction.reply({ embeds: [embed], ephemeral: true });
            }
        })
    },
};