/*
 * Copyright (c) 2014, Denis Dzyubenko <denis@ddenis.info>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are those
 * of the authors and should not be interpreted as representing official policies,
 * either expressed or implied, of the FreeBSD Project.
 */

#include "macpreferenceswindow.h"

#include <QVBoxLayout>
#include <QToolBar>
#include <QAction>
#include <QEvent>
#include <QWindow>
#include <QDebug>

#import <Cocoa/Cocoa.h>

struct PanelInfo
{
    PanelInfo(QAction *a, QWidget *p)
        : action(a), panel(p), windowSize(NSMakeSize(0, 0))
    { }

    QAction *action;
    QWidget *panel;
    NSSize windowSize;
};

class MacPreferencesWindowPrivate
{
public:
    MacPreferencesWindowPrivate(MacPreferencesWindow *q)
      : q(q), toolbar(0), currentPanelIndex(0)
    { }

    void displayPanel(int panelIndex);
    QSize guesstimateSizeHint(QWidget *w);
    bool isResizable(QWidget *w);
    QSize windowSizeForPanel(int panelIndex);
    void addCurrentPanelWidget();

    MacPreferencesWindow *q;

    QVBoxLayout *layout;
    QToolBar *toolbar;
    QList<PanelInfo> panels;
    int currentPanelIndex;
};

MacPreferencesWindow::MacPreferencesWindow(QWidget *parent)
    : QMainWindow(parent), d(new MacPreferencesWindowPrivate(this))
{
    setWindowFlags(windowFlags() & ~Qt::WindowFullscreenButtonHint);
    setUnifiedTitleAndToolBarOnMac(true);

    QWidget *centralWidget = new QWidget;
    d->layout = new QVBoxLayout(centralWidget);
    d->layout->setContentsMargins(0, 0, 0, 0);
    setCentralWidget(centralWidget);

    d->toolbar = addToolBar("maintoolbar");
    d->toolbar->setFloatable(false);
    d->toolbar->setMovable(false);
    d->toolbar->setIconSize(QSize(32, 32));
    d->toolbar->setToolButtonStyle(Qt::ToolButtonTextUnderIcon);
    d->toolbar->toggleViewAction()->setVisible(false);
}

MacPreferencesWindow::~MacPreferencesWindow()
{
    delete d;
}

int MacPreferencesWindow::addPreferencesPanel(const QIcon &icon, const QString &title, QWidget *widget)
{
    QAction *action = d->toolbar->addAction(icon, title);

    action->setCheckable(true);
    connect(action, SIGNAL(triggered(bool)), this, SLOT(toolButtonClicked()));

    d->panels.append(PanelInfo(action, widget));

    return d->panels.size()-1;
}

int MacPreferencesWindow::insertPreferencesPanel(int idx, const QIcon &icon, const QString &title, QWidget *widget)
{
    QAction *action = new QAction(icon, title, d->toolbar);
    d->toolbar->insertAction(idx < d->toolbar->actions().size() ? d->toolbar->actions().at(idx) : 0, action);

    action->setCheckable(true);
    connect(action, SIGNAL(triggered(bool)), this, SLOT(toolButtonClicked()));

    d->panels.insert(idx, PanelInfo(action, widget));

    widget->hide();

    if (idx < d->currentPanelIndex) {
        d->currentPanelIndex++;
    }

    return d->panels.size()-1;
}

void MacPreferencesWindow::removePreferencesPanel(QWidget *panel)
{
    int panelIndexToRemove = 0;
    for (int i = 0; i < d->panels.size(); ++i) {
        const PanelInfo &panelInfo = d->panels[i];
        if (panelInfo.panel == panel) {
            panelIndexToRemove = i;
            break;
        }
    }

    if (panelIndexToRemove < d->currentPanelIndex) {
        d->currentPanelIndex--;
    }

    const PanelInfo &panelInfo = d->panels.at(panelIndexToRemove);
    delete panelInfo.panel;
    delete panelInfo.action;
    d->panels.removeAt(panelIndexToRemove);

    d->displayPanel(0);
}

int MacPreferencesWindow::indexForPanel(QWidget *panel) {
    for (int i = 0; i < d->panels.size(); ++i) {
        const PanelInfo &panelInfo = d->panels[i];
        if (panelInfo.panel == panel) {
            return i;
        }
    }
    return -1;
}


int MacPreferencesWindow::currentPanelIndex() const
{
    return d->currentPanelIndex;
}

void MacPreferencesWindow::setCurrentPanelIndex(int panelIndex)
{
    if (d->currentPanelIndex == panelIndex)
        return;

    if (panelIndex < 0 || panelIndex >= d->panels.size())
        return;

    d->displayPanel(panelIndex);
}

QSize MacPreferencesWindowPrivate::guesstimateSizeHint(QWidget *w)
{
    if (w->minimumSize() == w->maximumSize())
        return w->minimumSize();
    return w->sizeHint();
}

bool MacPreferencesWindowPrivate::isResizable(QWidget *w)
{
    return w->minimumSize() != w->maximumSize();
}

QSize MacPreferencesWindowPrivate::windowSizeForPanel(int panelIndex)
{
    const PanelInfo &panelInfo = panels[panelIndex];
    QSize size = QSize(panelInfo.windowSize.width, panelInfo.windowSize.height);
    if (size.width() == 0 || size.height() == 0) {
        QSize panelSize = q->sizeHintForPanel(panelIndex);
        size = QSize(panelSize.width(), panelSize.height() + toolbar->size().height());
    }
    return size;
}

void MacPreferencesWindowPrivate::displayPanel(int panelIndex)
{
    PanelInfo &newPanel = panels[panelIndex];

    bool isUpdatingTheAlreadyVisiblePanel = panelIndex == currentPanelIndex;


    NSView *view = reinterpret_cast<NSView *>(q->effectiveWinId());
    NSRect frame = view.window.frame;

    static const int TitlebarHeight = 22;

    if (!isUpdatingTheAlreadyVisiblePanel) {
        PanelInfo &oldPanel = panels[currentPanelIndex];

        oldPanel.action->setChecked(false);

        oldPanel.panel->hide();
        layout->removeWidget(oldPanel.panel);

        oldPanel.windowSize = frame.size;
        // sigh. Ugly. Workaround. The titlebar height is included into the frame, which is fine, but Qt expects
        oldPanel.windowSize.height -= TitlebarHeight;
    }

    newPanel.action->setChecked(true);
    currentPanelIndex = panelIndex;

    QSize newSize = windowSizeForPanel(panelIndex);
    NSPoint topLeft = NSMakePoint(frame.origin.x, frame.origin.y + frame.size.height);
    NSRect newFrame = NSMakeRect(topLeft.x, topLeft.y - (newSize.height()+TitlebarHeight),
                                 newSize.width(), newSize.height()+TitlebarHeight);
    [view.window setFrame:newFrame display:YES animate:YES];

    if (isResizable(newPanel.panel)) {
        q->setMinimumSize(QSize(0, 0));
        q->setMaximumSize(QSize(QWIDGETSIZE_MAX, QWIDGETSIZE_MAX));
    } else {
        q->setFixedSize(QSize(newSize.width(), newSize.height()));
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        addCurrentPanelWidget();
    });
}

void MacPreferencesWindowPrivate::addCurrentPanelWidget()
{
    const PanelInfo &panelInfo = panels[currentPanelIndex];
    layout->addWidget(panelInfo.panel);
    panelInfo.panel->show();
}

int MacPreferencesWindow::preferencePanelCount()
{
    return d->panels.count();
}

void MacPreferencesWindow::toolButtonClicked()
{
    QAction *action = qobject_cast<QAction *>(sender());
    Q_ASSERT(action);

    action->setChecked(true);

    int panelIndex = 0;
    for (int i = 0; i < d->panels.size(); ++i) {
        const PanelInfo &panel = d->panels[i];
        if (panel.action == action) {
            panelIndex = i;
            break;
        }
    }

    setCurrentPanelIndex(panelIndex);

    emit activated(panelIndex);
}

bool MacPreferencesWindow::event(QEvent *event)
{
    switch (event->type()) {
    case QEvent::Show:
        d->displayPanel(d->currentPanelIndex);
        break;
    default:
        break;
    }

    return QMainWindow::event(event);
}

void MacPreferencesWindow::setVisible(bool visible)
{
    if (d->currentPanelIndex < d->panels.size()) {
        const PanelInfo &panelInfo = d->panels[d->currentPanelIndex];
        if (!d->isResizable(panelInfo.panel)) {
            QSize size = d->windowSizeForPanel(d->currentPanelIndex);
            setFixedSize(QSize(size.width(), size.height()-22));
        }
    }
    QMainWindow::setVisible(visible);
}

QSize MacPreferencesWindow::sizeHintForPanel(int panelIndex)
{
    Q_ASSERT(panelIndex >= 0 && panelIndex < d->panels.size());
    const PanelInfo &panelInfo = d->panels[panelIndex];
    return d->guesstimateSizeHint(panelInfo.panel);
}

QIcon MacPreferencesWindow::preferencesPanelIcon(int panelIndex) const
{
    if (panelIndex < 0 || panelIndex >= d->panels.size())
        return QIcon();

    return d->panels[panelIndex].action->icon();
}

void MacPreferencesWindow::setPreferencesPanelIcon(int panelIndex, const QIcon &icon)
{
    if (panelIndex < 0 || panelIndex >= d->panels.size())
        return;

    d->panels[panelIndex].action->setIcon(icon);
}

QString MacPreferencesWindow::preferencesPanelTitle(int panelIndex) const
{
    if (panelIndex < 0 || panelIndex >= d->panels.size())
        return QString();

    return d->panels[panelIndex].action->text();
}

void MacPreferencesWindow::setPreferencesPanelTitle(int panelIndex, const QString &title)
{
    if (panelIndex < 0 || panelIndex >= d->panels.size())
        return;

    d->panels[panelIndex].action->setText(title);
}
