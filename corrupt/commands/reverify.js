const { EmbedBuilder } = require('discord.js');

function daysBetween(dateString) {
    const d1 = new Date(dateString);
    const d2 = new Date();
    return Math.round((d2 - d1) / (1000 * 3600 * 24));
}

module.exports = {
    name: 'reverify',
    description: 'Reverify a player with a perm id and discord account.',
    options: [
        {
            name: 'user_id',
            type: 4,
            description: 'Perm ID',
            required: true,
        },
        {
            name: 'discord',
            type: 6,
            description: 'Discord Account',
            required: true,
        },
    ],
    perm: 8,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        if (!interaction) return;

        const fivemexports = client.fivemexports;
        const discord_id = interaction.options.getUser('discord').id;
        const permid = interaction.options.getInteger('user_id');
        fivemexports.corrupt.execute("UPDATE `corrupt_verification` SET discord_id = ?, verified = 1 WHERE user_id = ?", [discord_id, permid], (result) => {
            if (result) {
                const SuccessEmbed = new EmbedBuilder()
                    .setTitle('Corrupt Verification')
                    .setDescription(`Successfully reverified <@${discord_id}> with Perm ID: **${permid}**`)
                    .setColor(0x0078ff)
                    .setTimestamp();
                interaction.reply({ embeds: [SuccessEmbed], ephemeral: true });
                client.guilds.cache.get("1271575952115368008").members.fetch(discord_id).then(member => {
                    member.roles.add("1269355774954700886");
                });
                const verifylog = new EmbedBuilder()
                .setTitle('Corrupt Re-Verification Log')
                .setDescription('**Perm ID**\n' + permid + '\n\n**Discord**\n' + '<@' + discord_id + '>\n\n**Verified By**\n' + interaction.user.tag)
                .setColor(0x0078ff)
                .setTimestamp()
                client.channels.cache.get("1205922061902680084").send({ embeds: [verifylog] });
            }
        });
    },
};
