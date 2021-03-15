class SendEmailFromTemplateJob < ApplicationJob
  queue_as :default

  def perform(data)
    email_params = transform_email_params(data)

    EmailService.send_email(email_params)
  end

  def transform_email_params(data)
    data.symbolize_keys!

    {
      templateId: Integer(data[:template_id]),
      params: data[:template_options],
      to: [
        {
          name: data[:name],
          email: data[:email]
        }
      ],
      attachment: [
        data[:attachments].map do |attachment|
          {
            name: attachment[:filename],
            content: attachment[:encoded_file],
          }
        end
      ]
    }
  end
end

# EXAMPLE
# (priznanie)
#
#
# params = {
#   templateId: 139,
#   to: [
#     {
#       name: 'someone',
#       email: 'michal.rohacek@slovensko.digital'
#     }
#   ],
#   params: {
#     firstname: 'alojz',
#     lastname: 'kromka',
#     summary: {
#       prijmy: 100000,
#       priloha3_r13_zdravotne: 1,
#       priloha3_r11_socialne: 2,
#       priloha3_r08_poistne: 3,
#       r074_znizenie_partner: 4,
#       r106: 5,
#       r075_zaplatene_prispevky_na_dochodok: 6,
#       r076_kupele_spolu: 7,
#       r080_zaklad_dane_celkovo: 8,
#       na_vyplatenie: 9,
#       r125_dan_na_uhradu: 10,
#     },
#     newsletter: false
#   },
#   attachment: [
#     {
#       name: 'podklady-k-danovemu-priznaniu.xml',
#       content: 'PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPGRva3VtZW50PgogICA8aGxhdmlja2E+CiAgICAgIDxkaWM+OTAxMTE1Nzc3NTwvZGljPgogICAgICA8emFSb2s+MjAyMDwvemFSb2s+CiAgICAgIDxkb3ZvZERvcGxuZW5pYT4wPC9kb3ZvZERvcGxuZW5pYT4KICAgICAgPGZ5emlja2FPc29iYT4KICAgICAgICAgPHByaWV6dmlza28+VGVzdG92YWPDrTwvcHJpZXp2aXNrbz4KICAgICAgICAgPG1lbm8+Sm96ZWY8L21lbm8+CiAgICAgIDwvZnl6aWNrYU9zb2JhPgogICAgICA8c2lkbG8+CiAgICAgICAgIDxwc2M+ODUxMDE8L3BzYz4KICAgICAgICAgPHVsaWNhPkVpbnN0ZWlub3ZhPC91bGljYT4KICAgICAgICAgPHN1cGlzbmVPcmllbnRhY25lQ2lzbG8+ODQ2NS8xMjwvc3VwaXNuZU9yaWVudGFjbmVDaXNsbz4KICAgICAgICAgPG9iZWM+QnJhdGlzbGF2YTwvb2JlYz4KICAgICAgICAgPHN0YXQ+U2xvdmVuc2vDoSByZXB1Ymxpa2E8L3N0YXQ+CiAgICAgIDwvc2lkbG8+CiAgICAgIDxub3ZhTGVob3RhPgogICAgICAgICA8cHJlZGx6ZW5pZTQ5M2E+MTwvcHJlZGx6ZW5pZTQ5M2E+CiAgICAgICAgIDxwcmVkbHplbmllNDkzYj4wPC9wcmVkbHplbmllNDkzYj4KICAgICAgICAgPGRhdHVtTGVob3RhPjMwLjA2LjIwMjE8L2RhdHVtTGVob3RhPgogICAgICA8L25vdmFMZWhvdGE+CiAgICAgIDx2eXByYWNvdmFsPgogICAgICAgICA8ZG5hPjAyLjAyLjIwMjE8L2RuYT4KICAgICAgPC92eXByYWNvdmFsPgogICAgICA8cG9kcGlzPjE8L3BvZHBpcz4KICAgPC9obGF2aWNrYT4KPC9kb2t1bWVudD4K',
#     }
#   ],
# }

