const { EmbedBuilder, ButtonBuilder, ModalBuilder, ActionRowBuilder, TextInputBuilder, TextInputStyle } = require('discord.js');

function daysBetween(dateString) {
    const d1 = new Date(dateString);
    const d2 = new Date();
    return Math.round((d2 - d1) / (1000 * 3600 * 24));
}

module.exports = {
    name: 'verify',
    description: 'Verify the user with a code.',
    options: [
        {
            name: 'code',
            type: 3,
            description: 'Verification code',
            required: true,
        },
    ],
    perm: 0,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        if (!interaction) return;
        const fivemexports = client.fivemexports;
        const accountAgeInDays = daysBetween(interaction.user.createdAt);

        if (accountAgeInDays < 1) {
            const discordAccountageembed = new EmbedBuilder()
                .setTitle('Corrupt Verification')
                .setDescription('Your Discord account must be at least 15 days old to use this command.')
                .setColor(0xFF0000)
                .setTimestamp();

            return interaction.reply({ embeds: [discordAccountageembed], ephemeral: true });
        }

        fivemexports.corrupt.execute("SELECT * FROM `corrupt_verification` WHERE discord_id = ?", [interaction.user.id], (result) => {
            if (result.length > 0) {
                const alreadylinked = new EmbedBuilder()
                    .setTitle('Corrupt Verification')
                    .setDescription('Your Discord account is already linked to a Perm ID.')
                    .setColor(0xFF0000)
                    .setTimestamp();

                return interaction.reply({ embeds: [alreadylinked], ephemeral: true });
            }
        });

        fivemexports.corrupt.execute(
            "SELECT * FROM `corrupt_verification` WHERE code = ? AND verified = 0",
            [interaction.options.getString('code').toUpperCase()],
            (code) => {
                if (code.length > 0) {
                    if (code[0].discord_id === null) {
                        fivemexports.corrupt.execute(
                            "UPDATE `corrupt_verification` SET discord_id = ?, verified = 1 WHERE code = ?",
                            [interaction.user.id, interaction.options.getString('code').toUpperCase()],
                            async (result) => {
                                if (result) {
                                    const SuccessEmbed = new EmbedBuilder()
                                        .setTitle('Corrupt Verification')
                                        .setDescription('Your Account has been verified you can now connect to the server!')
                                        .setColor(0x0078ff)
                                        .setTimestamp();
                                    interaction.reply({ embeds: [SuccessEmbed], ephemeral: true });
                                    interaction.member.roles.add("1269355774954700886");

                                    const verifylog = new EmbedBuilder()
                                    .setTitle('Corrupt Verification Log')
                                    .setDescription('**Perm ID**\n' + code[0].user_id + '\n\n**Code**\n' + interaction.options.getString('code').toUpperCase() + '\n\n**Discord**\n' + interaction.user.username + ' - <@' + interaction.user.id + '>\n\n**Discord Created At**\n' + interaction.user.createdAt + '\n\n**Discord Account Age**\n' + accountAgeInDays + ' Days')
                                    .setColor(0x0078ff)
                                    .setTimestamp()
                                    client.channels.cache.get("1271173948016431134").send({ embeds: [verifylog] });
                                }
                            }
                        );
                    } else {
                        const alreadylinked = new EmbedBuilder()
                            .setTitle('Corrupt Verification')
                            .setDescription('Unable to verify you please contact a staff member.')
                            .setColor(0xFF0000)
                            .setTimestamp();

                        return interaction.reply({ embeds: [alreadylinked], ephemeral: true });
                    }
                } else {
                    const invalidcode = new EmbedBuilder()
                        .setTitle('Corrupt Verification')
                        .setDescription('Invalid Code, please try again with a valid code.')
                        .setColor(0xFF0000)
                        .setTimestamp();

                    return interaction.reply({ embeds: [invalidcode], ephemeral: true });
                }
            }
        );
    },
};
