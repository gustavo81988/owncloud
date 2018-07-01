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

#include "macstandardicon.h"

#include <QtMacExtras>
#include <QDebug>

#import <Cocoa/Cocoa.h>
#import <Availability.h>

static NSString *macIconNames[] = {

    NSImageNameQuickLookTemplate,
    NSImageNameBluetoothTemplate,
    NSImageNameIChatTheaterTemplate,
    NSImageNameSlideshowTemplate,
    NSImageNameActionTemplate,
    NSImageNameSmartBadgeTemplate,
    NSImageNameIconViewTemplate,
    NSImageNameListViewTemplate,
    NSImageNameColumnViewTemplate,
    NSImageNameFlowViewTemplate,
    NSImageNamePathTemplate,
    NSImageNameInvalidDataFreestandingTemplate,
    NSImageNameLockLockedTemplate,
    NSImageNameLockUnlockedTemplate,
    NSImageNameGoRightTemplate,
    NSImageNameGoLeftTemplate,
    NSImageNameRightFacingTriangleTemplate,
    NSImageNameLeftFacingTriangleTemplate,
    NSImageNameAddTemplate,
    NSImageNameRemoveTemplate,
    NSImageNameRevealFreestandingTemplate,
    NSImageNameFollowLinkFreestandingTemplate,
    NSImageNameEnterFullScreenTemplate,
    NSImageNameExitFullScreenTemplate,
    NSImageNameStopProgressTemplate,
    NSImageNameStopProgressFreestandingTemplate,
    NSImageNameRefreshTemplate,
    NSImageNameRefreshFreestandingTemplate,
    NSImageNameBonjour,
    NSImageNameComputer,
    NSImageNameFolderBurnable,
    NSImageNameFolderSmart,
    NSImageNameFolder,
    NSImageNameNetwork,
    NSImageNameDotMac,
    NSImageNameMobileMe,
    NSImageNameMultipleDocuments,
    NSImageNameUserAccounts,
    NSImageNamePreferencesGeneral,
    NSImageNameAdvanced,
    NSImageNameInfo,
    NSImageNameFontPanel,
    NSImageNameColorPanel,
    NSImageNameUser,
    NSImageNameUserGroup,
    NSImageNameEveryone,
    NSImageNameUserGuest,
    NSImageNameMenuOnStateTemplate,
    NSImageNameMenuMixedStateTemplate,
    NSImageNameApplicationIcon,
    NSImageNameTrashEmpty,
    NSImageNameTrashFull,
    NSImageNameHomeTemplate,
    NSImageNameBookmarksTemplate,
    NSImageNameCaution,
    NSImageNameStatusAvailable,
    NSImageNameStatusPartiallyAvailable,
    NSImageNameStatusUnavailable,
    NSImageNameStatusNone,
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_10_8
    NSImageNameShareTemplate,
#else
    nil,
#endif
    nil
};

QIcon MacStandardIcon::icon(MacStandardIconType icon, const QSize &size)
{
    NSImage *image = [NSImage imageNamed:macIconNames[icon]];
    if (!image) {
        qWarning("MacStandardIcon: something is wrong around here (%d)", (int)icon);
        return QIcon();
    }
    QList<NSRect> desiredRects;

    if (size.isEmpty()) {
        NSRect imageRect = NSMakeRect(0, 0, image.size.width, image.size.height);
        desiredRects.append(imageRect);
        while (imageRect.size.width > 32) {
            imageRect.size.width /= 2;
            imageRect.size.height /= 2;
            desiredRects.append(imageRect);
        }
    } else {
        desiredRects.append(NSMakeRect(0, 0, size.width(), size.height()));
    }

    QIcon result;

    foreach (NSRect rect, desiredRects) {
        CGImageRef cgimage = [image CGImageForProposedRect:&rect context:nil hints:nil];
        QPixmap pixmap = QtMac::fromCGImageRef(cgimage);

        result.addPixmap(pixmap);
    }

    return result;
}
