/**
 * Theme Manager - Handle Light/Dark Mode
 * Professional theme switching system
 */

class ThemeManager {
    constructor() {
        this.STORAGE_KEY = 'hotel-theme';
        this.THEME_LIGHT = 'light';
        this.THEME_DARK = 'dark';
        this.init();
    }

    /**
     * Initialize theme manager
     */
    init() {
        this.loadTheme();
        this.setupEventListeners();
    }

    /**
     * Load theme from localStorage or system preference
     */
    loadTheme() {
        let theme = localStorage.getItem(this.STORAGE_KEY);

        if (!theme) {
            // Check system preference
            if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
                theme = this.THEME_DARK;
            } else {
                theme = this.THEME_LIGHT;
            }
        }

        this.setTheme(theme);
    }

    /**
     * Set theme and update DOM
     */
    setTheme(theme) {
        const html = document.documentElement;
        
        if (theme === this.THEME_DARK) {
            html.setAttribute('data-theme', this.THEME_DARK);
            localStorage.setItem(this.STORAGE_KEY, this.THEME_DARK);
            this.updateThemeToggleButton(this.THEME_DARK);
        } else {
            html.removeAttribute('data-theme');
            localStorage.setItem(this.STORAGE_KEY, this.THEME_LIGHT);
            this.updateThemeToggleButton(this.THEME_LIGHT);
        }
    }

    /**
     * Toggle between light and dark theme
     */
    toggleTheme() {
        const currentTheme = this.getCurrentTheme();
        const newTheme = currentTheme === this.THEME_LIGHT ? this.THEME_DARK : this.THEME_LIGHT;
        this.setTheme(newTheme);
    }

    /**
     * Get current theme
     */
    getCurrentTheme() {
        return document.documentElement.getAttribute('data-theme') || this.THEME_LIGHT;
    }

    /**
     * Update theme toggle button appearance
     */
    updateThemeToggleButton(theme) {
        const buttons = document.querySelectorAll('.theme-toggle');
        buttons.forEach(btn => {
            const icon = btn.querySelector('i');
            const text = btn.querySelector('span');
            
            if (theme === this.THEME_DARK) {
                if (icon) icon.className = 'bi bi-sun-fill';
                if (text) text.textContent = 'Light';
            } else {
                if (icon) icon.className = 'bi bi-moon-fill';
                if (text) text.textContent = 'Dark';
            }
        });
    }

    /**
     * Setup event listeners for theme toggle
     */
    setupEventListeners() {
        document.addEventListener('click', (e) => {
            if (e.target.closest('.theme-toggle')) {
                this.toggleTheme();
            }
        });

        // Listen for system theme changes
        if (window.matchMedia) {
            window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
                if (!localStorage.getItem(this.STORAGE_KEY)) {
                    this.setTheme(e.matches ? this.THEME_DARK : this.THEME_LIGHT);
                }
            });
        }
    }
}

// Initialize theme manager when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        window.themeManager = new ThemeManager();
    });
} else {
    window.themeManager = new ThemeManager();
}
