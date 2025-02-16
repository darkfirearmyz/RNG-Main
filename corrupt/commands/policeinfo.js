const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "info",
    description: "Get Police Information About User Or Yourself",
    options: [
        {
            name: "user_id",
            description: "Perm ID (Optional)",
            type: 4,
            required: false,
        },
    ],
    perm: 0,
    guild: "1293662946592952442",
    run: async (client, interaction) => {
        const fivemexports = interaction.client.fivemexports;
        const level = interaction.client.getPerms(interaction.member);
        const permid = interaction.options.getInteger('user_id');

        if (!permid) {
            fivemexports.corrupt.execute("SELECT user_id FROM `corrupt_verification` WHERE discord_id = ?", [interaction.user.id], (result) => {
                if (result.length > 0) {
                    fivemexports.corrupt.execute("SELECT * FROM `corrupt_police_hours` WHERE user_id = ?", [result[0].user_id], (result) => {
                        if (result.length > 0) {
                            const embed = new EmbedBuilder()
                                .setTitle(`Met Police statistics for ${result[0].username}(${result[0].user_id})`)
                                .setColor(0x3498db)
                                .addFields(
                                    {name: 'Total hours:', value: `${result[0].total_hours.toFixed(2)}`, inline: true},
                                    {name: 'Total hours this week:', value: `${result[0].weekly_hours.toFixed(2)}`, inline: true},
                                    {name: 'Last clocked on as:', value: `${result[0].last_clocked_rank}`, inline: true},
                                    {name: 'Last clocked on date:', value: `${result[0].last_clocked_date}`, inline: true},
                                    {name: 'Total players jailed this week:', value: `${result[0].total_players_fined}`, inline: true},
                                    {name: 'Total players fined this week:', value: `${result[0].total_players_jailed}`, inline: true},
                                )
                                .setTimestamp(new Date());

                            interaction.reply({ embeds: [embed], ephemeral: true });
                        } else {
                            interaction.reply({ content: 'No Met Police statistics for this user.', ephemeral: true });
                        }
                    });
                } else {
                    interaction.reply({ content: 'You are not linked to a perm id.', ephemeral: true });
                }
            });
        } else {
            fivemexports.corrupt.execute("SELECT * FROM `corrupt_police_hours` WHERE user_id = ?", [permid], (result) => {
                if (result.length > 0) {
                    const embed = new EmbedBuilder()
                        .setTitle(`Met Police statistics for ${result[0].username}(${result[0].user_id})`)
                        .setColor(0x3498db)
                        .addFields(
                            {name: 'Total hours:', value: `${result[0].total_hours.toFixed(2)}`, inline: true},
                            {name: 'Total hours this week:', value: `${result[0].weekly_hours.toFixed(2)}`, inline: true},
                            {name: 'Last clocked on as:', value: `${result[0].last_clocked_rank}`, inline: true},
                            {name: 'Last clocked on date:', value: `${result[0].last_clocked_date}`, inline: true},
                            {name: 'Total players jailed this week:', value: `${result[0].total_players_fined}`, inline: true},
                            {name: 'Total players fined this week:', value: `${result[0].total_players_jailed}`, inline: true},
                        )
                        .setTimestamp(new Date());

                    interaction.reply({ embeds: [embed], ephemeral: true });
                } else {
                    interaction.reply({ content: 'No Met Police statistics for this user.', ephemeral: true });
                }
            });
        }
    },
};
