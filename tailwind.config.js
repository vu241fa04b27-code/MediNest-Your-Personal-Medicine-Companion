/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      screens: {
        'xs': '360px',
      },
      colors: {
        med: {
          green: '#4CAF50',
          greenDark: '#2E7D32',
          greenLight: '#E8F5E9',
          blue: '#2196F3',
          blueDark: '#1565C0',
          blueLight: '#E3F2FD',
          bg: '#F8FAFC',
          card: '#FFFFFF',
          text: '#1E293B',
          muted: '#64748B',
          border: '#E2E8F0',
          danger: '#D32F2F',
          dangerLight: '#FFEBEE',
          warning: '#ED6C02',
          warningLight: '#FFF3E0'
        }
      },
      borderRadius: {
        '2xl': '20px',
        '3xl': '24px'
      }
    },
  },
  plugins: [],
}
