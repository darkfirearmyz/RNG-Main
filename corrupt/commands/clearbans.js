const { EmbedBuilder } = require('discord.js');

module.exports = {
    name: 'clearbans',
    description: 'Clear All Player Bans',
    options: [
        {
            name: "all",
            description: "Clear All Bans (Default: Non-Cheater Bans)",
            type: 5,
            required: false,
        }
    ],
    perm: 9,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        const fivemexports = client.fivemexports;
        const admin = interaction.user;
        const all = interaction.options.getBoolean('all');

        fivemexports.corrupt.execute("SELECT * FROM corrupt_users WHERE banned = 1", [], (result) => {
            if (result && result.length > 0) {
                for (const item of result) {
                    const reason = item.banreason.toLowerCase();
                    if (all) {
                        let newval = fivemexports.corrupt.corruptbot('setBanned', [parseInt(item.id), false])
                        const allembed = new EmbedBuilder()
                            .setTitle('All Bans Cleared')
                            .setDescription(`Number of Bans removed: ${result.length}`)
                            .setColor(settingsjson.settings.botColour)
                            .setTimestamp(new Date())
                        interaction.reply({ embeds: [allembed], ephemeral: true });
                        // const allannouncement = new EmbedBuilder()
                        //     .setTitle('All Bans Cleared')
                        //     .setDescription(`Number of Bans removed: ${result.length}`)
                        //     .setColor(settingsjson.settings.botColour)
                        //     .setTimestamp(new Date())
                        // return client.channels.cache.get("1205921945934372865").send({ embeds: [allannouncement], content: `@everyone` })
                    } else if (!reason.includes('cheating')) {
                        let totalnoncheatbans = 0;
                        totalnoncheatbans++;
                        let newval = fivemexports.corrupt.corruptbot('setBanned', [parseInt(item.id), false])
                        const noncheatembed = new EmbedBuilder()
                            .setTitle('Non Cheater Bans Cleared')
                            .setDescription(`Number of Bans removed: ${totalnoncheatbans}`)
                            .setColor(settingsjson.settings.botColour)
                            .setTimestamp(new Date())
                        interaction.reply({ embeds: [noncheatembed], ephemeral: true })
                        // const nonannouncement = new EmbedBuilder()
                        //     .setTitle('Non Cheater Bans Cleared')
                        //     .setDescription(`Number of Bans removed: ${totalnoncheatbans}`)
                        //     .setColor(settingsjson.settings.botColour)
                        //     .setTimestamp(new Date())
                        // return client.channels.cache.get("1205921945934372865").send({ embeds: [nonannouncement], content: `@everyone` })
                    }
                }
            } else {
                return interaction.reply({ content: 'No bans found to clear.', ephemeral: true });
            }
        });
    },
};
