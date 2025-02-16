const { ActionRowBuilder, ButtonBuilder, EmbedBuilder, ButtonStyle } = require('discord.js');

function generateUUID(length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const charsLength = characters.length;

    let uuid = '';
    for (let i = 0; i < length; i++) {
        const randomIndex = Math.floor(Math.random() * charsLength);
        uuid += characters.charAt(randomIndex);
    }

    return uuid;
}

module.exports = {
    name: "addrank",
    description: "Add a rank to a player store.",
    options: [
        {
            name: "user_id",
            description: "Perm ID",
            type: 4,
            required: true,
        },
        {
            name: "rank",
            description: "Rank",
            type: 3,
            required: true,
            choices: [
                {
                    name: "Supporter",
                    value: "supporter"
                },
                {
                    name: "Premium",
                    value: "premium"
                },
                {
                    name: "Supreme",
                    value: "supreme"
                },
                {
                    name: "King Pin",
                    value: "kingpin"
                },
                {
                    name: "Rainmaker",
                    value: "rainmaker"
                },
                {
                    name: "Baller",
                    value: "baller"
                }
            ]
        }
    ],
    perm: 9,
    guild: "1271575952115368008",
    support: true,
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);
        let permid = interaction.options.getInteger('user_id');
        let ranktoadd = interaction.options.getString('rank');
        const code1 = generateUUID(4);
        const code2 = generateUUID(4);
        const code = (code1 + "-" + code2).toUpperCase();

        const embed = new EmbedBuilder()
            .setTitle("Rank Confirmation")
            .setColor("#0078FF")
            .setDescription(`**Perm ID:** ${permid}\n**Rank:** ${ranktoadd}\n**Code:** ${code}`)
            .setFooter({text: "This confirmation will time out in 15 seconds."})
            .setTimestamp();

        const row = new ActionRowBuilder()
            .addComponents(
                new ButtonBuilder()
                    .setCustomId('confirm')
                    .setLabel('Confirm')
                    .setStyle(ButtonStyle.Success),
                new ButtonBuilder()
                    .setCustomId('cancel')
                    .setLabel('Cancel')
                    .setStyle(ButtonStyle.Danger)
            );
        
        interaction.reply({ embeds: [embed], components: [row], ephemeral: true });

        const filter = i => i.customId === 'confirm' || i.customId === 'cancel';
        const collector = interaction.channel.createMessageComponentCollector({ filter, time: 30000 });
        collector.on('collect', async i => {
            if (i.customId === 'confirm') {
                collector.stop();
                await i.deferUpdate();
                fivemexports.corrupt.execute("INSERT INTO corrupt_stores (code, item, user_id) VALUES (?, ?, ?)", [code, ranktoadd, permid]);

                const embed = new EmbedBuilder()
                    .setTitle("Rank Added")
                    .setColor("#0078FF")
                    .setDescription(`**Perm ID:** ${permid}\n**Rank:** ${ranktoadd}\n**Code:** ${code}`)
                    .setTimestamp();
                interaction.editReply({ embeds: [embed], components: [] });
            } else {
                collector.stop();
                await i.deferUpdate();
                const embed = new EmbedBuilder()
                    .setTitle("Cancelled")
                    .setColor("#FF0000")
                    .setDescription("Rank addition has been cancelled.")
                    .setTimestamp();
                interaction.editReply({ embeds: [embed], components: [] });
            }
        });
    }
};
