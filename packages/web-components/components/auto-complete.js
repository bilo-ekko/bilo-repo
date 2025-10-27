class AutoComplete extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: 'open' });
    this.options = [];
    this.filteredOptions = [];
    this.selectedIndex = -1;
    this.isOpen = false;
  }

  static get observedAttributes() {
    return ['placeholder', 'options'];
  }

  connectedCallback() {
    this.render();
    this.setupEventListeners();
  }

  attributeChangedCallback(name, oldValue, newValue) {
    if (name === 'options' && newValue) {
      this.options = JSON.parse(newValue);
      this.filteredOptions = [...this.options];
    }
    this.render();
  }

  render() {
    this.shadowRoot.innerHTML = `
      <style>
        :host {
          display: block;
          position: relative;
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        .autocomplete-container {
          position: relative;
          width: 100%;
        }
        
        .search-input {
          width: 100%;
          padding: 12px 16px;
          border: 2px solid #e1e5e9;
          border-radius: 8px;
          font-size: 16px;
          outline: none;
          transition: border-color 0.2s ease;
          box-sizing: border-box;
        }
        
        .search-input:focus {
          border-color: #007bff;
        }
        
        .dropdown {
          position: absolute;
          top: 100%;
          left: 0;
          right: 0;
          background: white;
          border: 2px solid #e1e5e9;
          border-top: none;
          border-radius: 0 0 8px 8px;
          max-height: 200px;
          overflow-y: auto;
          z-index: 1000;
          display: none;
          box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .dropdown.open {
          display: block;
        }
        
        .option {
          padding: 12px 16px;
          cursor: pointer;
          transition: background-color 0.2s ease;
          border-bottom: 1px solid #f0f0f0;
        }
        
        .option:last-child {
          border-bottom: none;
        }
        
        .option:hover,
        .option.selected {
          background-color: #f8f9fa;
        }
        
        .option.highlighted {
          background-color: #e3f2fd;
        }
        
        .no-results {
          padding: 12px 16px;
          color: #666;
          font-style: italic;
        }
      </style>
      
      <div class="autocomplete-container">
        <input 
          type="text" 
          class="search-input" 
          placeholder="${this.getAttribute('placeholder') || 'Search...'}"
          autocomplete="off"
        />
        <div class="dropdown">
          ${this.renderOptions()}
        </div>
      </div>
    `;
  }

  renderOptions() {
    if (this.filteredOptions.length === 0) {
      return '<div class="no-results">No results found</div>';
    }
    
    return this.filteredOptions.map((option, index) => `
      <div 
        class="option ${index === this.selectedIndex ? 'highlighted' : ''}" 
        data-value="${option.value || option}"
        data-index="${index}"
      >
        ${option.label || option}
      </div>
    `).join('');
  }

  setupEventListeners() {
    const input = this.shadowRoot.querySelector('.search-input');
    const dropdown = this.shadowRoot.querySelector('.dropdown');

    input.addEventListener('input', (e) => {
      this.handleInput(e.target.value);
    });

    input.addEventListener('focus', () => {
      this.openDropdown();
    });

    input.addEventListener('blur', (e) => {
      // Delay to allow option clicks to register
      setTimeout(() => {
        this.closeDropdown();
      }, 150);
    });

    input.addEventListener('keydown', (e) => {
      this.handleKeydown(e);
    });

    dropdown.addEventListener('click', (e) => {
      const option = e.target.closest('.option');
      if (option) {
        this.selectOption(option.dataset.value, option.textContent);
      }
    });
  }

  handleInput(value) {
    this.filteredOptions = this.options.filter(option => {
      const text = option.label || option;
      return text.toLowerCase().includes(value.toLowerCase());
    });
    this.selectedIndex = -1;
    this.openDropdown();
    this.render();
    
    // Dispatch custom event
    this.dispatchEvent(new CustomEvent('search', {
      detail: { value, filteredOptions: this.filteredOptions }
    }));
  }

  handleKeydown(e) {
    if (!this.isOpen) {
      if (e.key === 'ArrowDown' || e.key === 'Enter') {
        this.openDropdown();
      }
      return;
    }

    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault();
        this.selectedIndex = Math.min(this.selectedIndex + 1, this.filteredOptions.length - 1);
        this.render();
        break;
      case 'ArrowUp':
        e.preventDefault();
        this.selectedIndex = Math.max(this.selectedIndex - 1, -1);
        this.render();
        break;
      case 'Enter':
        e.preventDefault();
        if (this.selectedIndex >= 0) {
          const option = this.filteredOptions[this.selectedIndex];
          this.selectOption(option.value || option, option.label || option);
        }
        break;
      case 'Escape':
        this.closeDropdown();
        break;
    }
  }

  selectOption(value, label) {
    const input = this.shadowRoot.querySelector('.search-input');
    input.value = label;
    this.closeDropdown();
    
    // Dispatch custom event
    this.dispatchEvent(new CustomEvent('select', {
      detail: { value, label }
    }));
  }

  openDropdown() {
    this.isOpen = true;
    const dropdown = this.shadowRoot.querySelector('.dropdown');
    dropdown.classList.add('open');
  }

  closeDropdown() {
    this.isOpen = false;
    const dropdown = this.shadowRoot.querySelector('.dropdown');
    dropdown.classList.remove('open');
  }

  // Public methods
  setOptions(options) {
    this.options = options;
    this.filteredOptions = [...options];
    this.render();
  }

  getValue() {
    const input = this.shadowRoot.querySelector('.search-input');
    return input.value;
  }

  setValue(value) {
    const input = this.shadowRoot.querySelector('.search-input');
    input.value = value;
  }
}

customElements.define('auto-complete', AutoComplete);

